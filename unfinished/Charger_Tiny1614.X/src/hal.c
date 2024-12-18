#include "board.h"
#include <avr/io.h>
#include <avr/sleep.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
#include <string.h>

#define ADC0_VREF 2500
#define DAC0_VREF 2500
#define DAC1_VREF 1100

#define BAK_BUTTON_PIN_POS (1<<BAK_BUTTON_PIN)
#define PSH_BUTTON_PIN_POS (1<<PSH_BUTTON_PIN)
#define TRA_PIN_POS (1<<TRA_PIN)
#define TRB_PIN_POS (1<<TRB_PIN)

FUSES = {
        .WDTCFG = 0x00, // WDTCFG {PERIOD=OFF, WINDOW=OFF}
        .BODCFG = 0x55, // BODCFG {SLEEP=ENABLED, ACTIVE=ENABLED, SAMPFREQ=125HZ, LVL=BODLEVEL2} 2.6v
        .OSCCFG = 0x02, // OSCCFG {FREQSEL=20MHZ, OSCLOCK=CLEAR}
        .TCD0CFG = 0x00, // TCD0CFG {CMPA=CLEAR, CMPB=CLEAR, CMPC=CLEAR, CMPD=CLEAR, CMPAEN=CLEAR, CMPBEN=CLEAR, CMPCEN=CLEAR, CMPDEN=CLEAR}
        .SYSCFG0 = 0xF6, // SYSCFG0 {EESAVE=CLEAR, RSTPINCFG=UPDI, CRCSRC=NOCRC}
        .SYSCFG1 = 0x07, // SYSCFG1 {SUT=64MS}
        .APPEND = 0x00, // APPEND {APPEND=User range:  0x0 - 0xFF}
        .BOOTEND = 0x00, // BOOTEND {BOOTEND=User range:  0x0 - 0xFF}
};

LOCKBITS = 0xC5; // {LB=NOLOCK}

static volatile unsigned char delay;

static volatile const unsigned char *twi_ptr;
static volatile unsigned int twi_rest;
static volatile unsigned char twi_sending;
static volatile unsigned char twi_error;
static volatile char encoder_counter, exit_counter, keyboard_state;
static unsigned long ref;
static int set_current_value;

// RTC counter interrupt
ISR(RTC_CNT_vect)
{
    delay++;
    RTC.INTFLAGS = 0x03; // clear interrupt flags
}

ISR(TWI0_TWIM_vect)
{
    if(TWI0.MSTATUS & TWI_RXACK_bm){
        twi_error = 1;
        twi_sending = 0;
        TWI0.MCTRLB |= TWI_ACKACT_NACK_gc;
        TWI0.MCTRLB |= TWI_MCMD_STOP_gc;
    }
    else if(twi_rest){
        // Send Next Character
        twi_rest--;
        TWI0.MSTATUS |= TWI_WIF_bm | TWI_RIF_bm;
        TWI0.MDATA = *twi_ptr++;
    }else{
        // Generate STOP Condition
        TWI0.MCTRLB |= TWI_ACKACT_NACK_gc;
        TWI0.MCTRLB |= TWI_MCMD_STOP_gc;
        twi_sending = 0;
    }
}

ISR(PORTA_PORT_vect)
{
    if (PORTA.INTFLAGS & PSH_BUTTON_PIN_POS)
        keyboard_state = KB_SELECT;
    else
    {
        if (PORTA.IN & TRA_PIN_POS)
            encoder_counter--;
        else
            encoder_counter++;
    }
    PORTA.INTFLAGS = TRA_PIN_POS | TRB_PIN_POS | PSH_BUTTON_PIN_POS;
}

ISR(PORTB_PORT_vect)
{
    keyboard_state = KB_EXIT;
    PORTB.INTFLAGS = BAK_BUTTON_PIN_POS;
}

void delayms(unsigned int ms)
{
    sleep_cpu();
    for (;;)
    {
        sleep_cpu();
        if (ms > RTC_INT_MS)
            ms -= RTC_INT_MS;
        else
            break;
    }
}

static void TWI_sendMessage(unsigned char address, const unsigned char *message, unsigned int length)
{
    twi_ptr = message;
    twi_rest = length;

    twi_sending = 1;

    // Send Slave Address(Start Sending)
    TWI0.MADDR = address;

    // Wait until finished
    while(twi_sending)
        sleep_cpu();
}


int SSD1306_I2C_Write(int num_bytes, unsigned char control_byte, unsigned char *buffer)
{
  static unsigned char twi_buffer[130];
    
  twi_buffer[0] = control_byte;
  memcpy(twi_buffer + 1, buffer, num_bytes);
  TWI_sendMessage(SSD1306_I2C_ADDRESS, twi_buffer, num_bytes + 1);
  return twi_error;
}

void save_data(void *p, unsigned int size)
{
    eeprom_write_block(p, 0, size);
}

void load_data(void *p, unsigned int size)
{
    eeprom_read_block(p, 0, size);
}

/*
 * PB0 SCL
 * PB1 SDA
 * PB2 BAK
 * PB3 AC1_OUT
 * PA0 UPDI
 * PA1 PSH
 * PA2 TRA
 * PA3 TRB
 * PA4 AIN4 (I_SENSE_HI)
 * PA5 AIN5 (V_SENSE)
 * PA6 DAC0_OUT
 * PA7 AC1_INP0,AIN7 (I_SENSE_LO)
 */

static unsigned long adc_get(unsigned char ain)
{
    ADC0.MUXPOS = ain;
    ADC0.COMMAND = ADC_STCONV_bm;
    while (ADC0.COMMAND & ADC_STCONV_bm)
        ;
    return (unsigned long)ADC0.RES;
}

static unsigned int get_mv(unsigned char ain)
{
    ref = adc_get(ADC_MUXPOS_INTREF_gc);
    unsigned long val = adc_get(ain);
    return (unsigned int)(ADC0_VREF * val / ref);
}

unsigned int get_voltage(void)
{
    return get_mv(ADC_MUXPOS_AIN5_gc);
}

void set_current(int mA)
{
    set_current_value = mA;
    if (mA == 0)
    {
        DAC0.DATA = 0;
        DAC1.DATA = 0;
        return;
    }
    if (mA > 0) // charge
    {
        DAC1.DATA = 0;
        DAC0.DATA = (unsigned char)((unsigned long)mA * (255 * MAX_CURRENT / DAC0_VREF) / MAX_CURRENT);
        return;
    }
    mA = -mA;
    DAC0.DATA = 0;
    DAC1.DATA = (unsigned char)((unsigned long)(mA >> 1) * 255 / DAC1_VREF);
}

static int get_current_hi(void)
{
    unsigned int vcc = (unsigned int)((unsigned long)ADC0_VREF * (unsigned long)1023 / ref);
    unsigned int mv = get_mv(ADC_MUXPOS_AIN4_gc);
    if (mv >= vcc)
        return 0;
    return (int)((vcc - mv) << 1); // 0.47 Ohm resistor
}

static int get_current_lo(void)
{
    unsigned int mv = get_mv(ADC_MUXPOS_AIN7_gc);
    return (int)(mv << 1); // 0.47 Ohm resistor
}

int get_current(void)
{
    if (set_current_value == 0)
        return 0;
    if (set_current_value > 0) // charge
        return get_current_hi();
    return -get_current_lo();
}

char get_keyboard_status(void)
{
  if (!(BAK_BUTTON_PORT.IN & BAK_BUTTON_PIN_POS))
  {
      exit_counter++;
      return 0;
  }
  if (exit_counter)
  {
      char status = exit_counter > 2 ? KB_EXIT_LONG : KB_EXIT;
      exit_counter = 0;
      keyboard_state = 0;
      return status;
  }
  if (keyboard_state)
  {
      char status = keyboard_state;
      keyboard_state = 0;
      return status;
  }
  if (encoder_counter)
  {
      cli();
      char cnt = encoder_counter;
      encoder_counter = 0;
      sei();
      return KB_ENCODER | (cnt << 4);
  }
  return 0;
}

static void InitPorts(void)
{
    //LED_PORT.DIR = 1 << LED_PIN;
    // PSH pin
    PORTA.PIN1CTRL = 3; // falling edge interrupt
    // TRB pin
    PORTA.PIN3CTRL = 3; // falling edge interrupt
    // BAK pin
    PORTB.PIN2CTRL = 3; // falling edge interrupt
}

#define RTC_PER_VALUE (32768/(1000 / RTC_INT_MS))

static void InitRTC(void)
{
    RTC.INTCTRL = 0x01; // OVF Interrupt enable
    RTC.PERL = RTC_PER_VALUE & 0xFF; // 20 Hz interrupt
    while (RTC.STATUS)
        ;
    RTC.PERH = RTC_PER_VALUE >> 8;   // 20 Hz interrupt
    while (RTC.STATUS)
        ;
    RTC.CLKSEL = 0x00; // 32768 Hz clock
    RTC.CTRLA = 0x01; // RTC enabled, no prescaling
}

static void InitDAC0(void)
{
    DAC0.DATA = 0;
    DAC0.CTRLA = 0x01; // DAC enable
}

static void InitDAC1(void)
{
    DAC1.DATA = 0;
    DAC1.CTRLA = 0x01; // DAC enable
}

static void InitVREF(void)
{
    VREF.CTRLA = 0x22; // ADC0REF = 2.5v, DAC0REF = 2.5v
    VREF.CTRLC = 1; // DAC1 reference = 1.1v
    VREF.CTRLB = 0x0B; // Enable references for DAC0, ADC0, DAC1
}

static void InitADC(void)
{
    ADC0.CTRLB = 4; // 16 results accumulated
    ADC0.CTRLC = ADC_REFSEL_VDDREF_gc | ADC_PRESC_DIV16_gc; // VRef = VDD, CLK_ADC=CLK_PER/16
    ADC0.CTRLA = ADC_ENABLE_bm;
}

static void InitComparator1(void)
{
    AC1.MUXCTRLA = 0x83; // invert output, positive input - AINP0, negative input - DAC
    AC1.CTRLA = 0x41; // Comparator enable, output enable
}

/* TWI Baud Rate Calculation
 * CLK_PER is 20 MHz
 *
 * Requested Baud Rate: f_SCL = 100 KHz
 * register parameter: BAUD = (CLK_PER - f_SCL*(10+CLK_PER*t_RISE)) / (2*f_SCL)
 *  t_RISE = 300[ns] = 3.0e-7[s]
 */
#define F_RISE 3000
#define TWI_PARAM_BAUD (CLK_PER / (2 * F_SCL) - (5 + CLK_PER/F_RISE/2))

static void InitI2C(void)
{
    twi_sending = twi_error = 0;
    TWI0.MBAUD = TWI_PARAM_BAUD;
    TWI0.MCTRLA = TWI_WIEN_bm | TWI_ENABLE_bm;
    TWI0.MSTATUS |= TWI_RIF_bm | TWI_WIF_bm;
    TWI0.MSTATUS |= TWI_BUSSTATE_IDLE_gc;
}

void SystemInit(void)
{
    delay = 0;
    encoder_counter = 0;
    exit_counter = 0;
    keyboard_state = 0;
    
    InitVREF();
    InitPorts();
    InitADC();
    InitDAC0();
    InitDAC1();
    InitComparator1();
    InitRTC();
    InitI2C();

    sleep_enable();
    set_sleep_mode(SLEEP_MODE_IDLE);
}