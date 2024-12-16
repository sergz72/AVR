#include "board.h"
#include <avr/io.h>
#include <avr/sleep.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
#include <string.h>

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

volatile unsigned char delay;

volatile const unsigned char *twi_ptr;
volatile unsigned int twi_rest;
volatile unsigned char twi_sending;
volatile unsigned char twi_error;
volatile char encoder_counter, exit_counter;

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
    if (PORTA.IN & 4)
        encoder_counter--;
    else
        encoder_counter++;
    PORTA.INTFLAGS = 4 | 8;
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

void TWI_sendMessage(unsigned char address, const unsigned char *message, unsigned int length)
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

unsigned int get_voltage(void)
{
  //todo
  return 3700;
}

void set_current(int mA)
{
  //todo
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
 * PA5 AC1_INN0
 * PA6 DAC0_OUT
 * PA7 AIN7 (I_SENSE_LO)
 */

char get_keyboard_status(void)
{
  if (!(PORTB.IN & 4))
  {
      exit_counter++;
      return 0;
  }
  if (exit_counter)
  {
      char status = exit_counter > 2 ? KB_EXIT_LONG : KB_EXIT;
      exit_counter = 0;
      return status;
  }
  unsigned char state = PORTA.IN;
  if (!(state & 2))
      return KB_SELECT;
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
    //PORTA.PIN2CTRL = 3; // falling edge interrupt
    PORTA.PIN3CTRL = 3; // falling edge interrupt
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
    VREF.CTRLC = 2; // DAC1 reference = 2.5v
    VREF.CTRLB = 0x0B; // Enable references for DAC0, ADC0, DAC1
}

static void InitADC(void)
{
    //ADC0.CTRLB = ADC_SAMPNUM_ACC1_gc; // No accumulation
    //ADC0.CTRLC = ADC_REFSEL_INTREF_gc | ADC_PRESC_DIV16_gc; // Internal VRef, CLK_ADC=CLK_PER/16
    //ADC0.MUXPOS = AIN6; // select target pin
    //ADC0.CTRLA = ADC_RESSEL_8BIT_gc | ADC_ENABLE_bm; // 8-bit mode
    //todo
}

static void InitComparator1(void)
{
    AC1.MUXCTRLA = 0x0B; // not invert output, positive input - AINP1, negative input - DAC
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