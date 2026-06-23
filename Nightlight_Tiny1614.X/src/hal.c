#include "board.h"
#include <avr/io.h>
#include <avr/sleep.h>
#include <avr/interrupt.h>
#include <avr/cpufunc.h>
#include <avr/wdt.h>
#include "usart_handler.h"
#include <stdio.h>
#include <rtc_pcf8563.h>
#include <i2c_tiny1614.h>

FUSES = {
  .WDTCFG = 0x07, // WDTCFG {PERIOD=0.5s, WINDOW=OFF}
  .BODCFG = 0x55, // BODCFG {SLEEP=ENABLED, ACTIVE=ENABLED, SAMPFREQ=125HZ, LVL=BODLEVEL2} 2.6v
  .OSCCFG = 0x01, // OSCCFG {FREQSEL=16MHZ, OSCLOCK=CLEAR}
  .TCD0CFG = 0x00, // TCD0CFG {CMPA=CLEAR, CMPB=CLEAR, CMPC=CLEAR, CMPD=CLEAR, CMPAEN=CLEAR, CMPBEN=CLEAR, CMPCEN=CLEAR, CMPDEN=CLEAR}
  .SYSCFG0 = 0xF6, // SYSCFG0 {EESAVE=CLEAR, RSTPINCFG=UPDI, CRCSRC=NOCRC}
  .SYSCFG1 = 0x07, // SYSCFG1 {SUT=64MS}
  .APPEND = 0x00, // APPEND {APPEND=User range:  0x0 - 0xFF}
  .BOOTEND = 0x00, // BOOTEND {BOOTEND=User range:  0x0 - 0xFF}
};

LOCKBITS = 0xC5; // {LB=NOLOCK}

volatile unsigned char timer_interrupt, rtc_interrupt;

#ifdef USART_ENABLED
int usart_fputchar(char c, FILE *stream);
FILE usart_stdout = FDEV_SETUP_STREAM(usart_fputchar, NULL, _FDEV_SETUP_WRITE);
#endif

// RTC counter interrupt
ISR (RTC_PIT_vect)
{
  wdt_reset();
  timer_interrupt = 1;
  RTC.PITINTFLAGS = 1; // clear interrupt flag
}

ISR (INT_PORT_vect)
{
  if (INT_PORT.INTFLAGS & (1 << INT_PIN))
    rtc_interrupt = 1;
  INT_PORT.INTFLAGS = 0xFF;
}

#ifdef USART_ENABLED
ISR (USART0_RXC_vect)
{
  if (USART0.STATUS & 0x80)
  {
    unsigned char c = USART0.RXDATAL;
    usart_interrupt_handler(c);
  }
}
#endif

/*
 * PB0(9)  SCL
 * PB1(8)  SDA
 * PB2(7)  TX
 * PB3(6)  RX
 * PA0(10) UPDI
 * PA1(11) INT
 * PA2(12) LED_TIMER
 * PA3(13) LED_BATTERY
 * PA4(2)  TCD WOA
 * PA5(3)
 * PA6(4)  AC1 AINP1
 * PA7(5)
 */

static void
InitPorts (void)
{
  LED_TIMER_PORT.DIRSET = 1 << LED_TIMER_PIN;
  LED_BATTERY_PORT.DIRSET = 1 << LED_BATTERY_PIN;
  INT_PORT.INT_PINCTRL = 0b00001011; // pullup enable, falling edge interrupt
}

static void
InitRTC (void)
{
  RTC.PITCTRLA   = 0b01011001; // enabled, interrupt each 4096 cycles
  RTC.PITINTCTRL = 1; // periodic interrupt is enabled
}

static void InitVREF(void)
{
  VREF.CTRLA = 0b01000000; // ADC0 reference = 1.5v, DAC0 reference = 0.55v
  VREF.CTRLC = 0b00000000; // ADC1 reference = 0.55v, DAC1 reference = 0.55v
  VREF.CTRLB = 0b00001010; // Enable references for ADC0, DAC1
}

static void InitDAC1(void)
{
  DAC1.DATA  = DAC1_VALUE;
  DAC1.CTRLA = 0x01; // DAC enable
}

static void InitComparator1(void)
{
  PORTA.PIN6CTRL = 4; // digital intput buffer disable
  
  AC1.MUXCTRLA = 0b00001011; // invert output, positive input - AINP1, negative input - DAC
  AC1.CTRLA    = 0b00000001; // Comparator enable, output disable

  // 2. Route AC0 output to Event System Channel 0
  EVSYS.ASYNCCH0   = EVSYS_ASYNCCH0_AC1_OUT_gc; // AC1_OUT
  EVSYS.ASYNCUSER6 = 3; // ASYNCCH0 -> Timer Counter D 0 Event 0
}

static void
InitADC0(void)
{
  ADC0.MUXPOS   = 0x1D; // internal reference
  ADC0.CTRLB    = 0b00000000; // No accumulation
  ADC0.CTRLC    = 0b01010011; // Prescaler: 16, REFSEL = VDD, Reduced size of sampling capacitance. Recommended for higher reference voltages.
  ADC0.SAMPCTRL = 0; // sampling time - two adc cycles
  ADC0.CTRLA    = 0b00000001; // ADC enabled
}

static void
InitPWM(void)
{
  TCD0.CTRLB   = 0; // WGMODE = OneRamp
  TCD0.CTRLC   = 0;
  TCD0.CTRLD   = 0;
  TCD0.CTRLE   = 0;
  TCD0.CMPASET = 0;
  TCD0.CMPACLR = PWM_DUTY;
  TCD0.CMPBSET = 0;
  TCD0.CMPBCLR = PWM_CMP_CALC(PWM_FREQUENCY); // period
  TCD0.INPUTCTRLA = 6; // WAIT
  TCD0.EVCTRLA = 0b10010101; // Async event, rising edge, fault event, enabled
  
  PWM_PORT.DIRSET = 1 << PWM_PIN;
}

#ifdef USART_ENABLED
static void
InitUsart (void)
{
  stdout = &usart_stdout;
  
  // read signed error
  signed char sigrow_val = SIGROW.OSC16ERR3V;
  // ideal BAUD register value
  signed long baud_reg_val = CLK_PER * 4L / USART_BAUD; 
  baud_reg_val *= 1024 + sigrow_val; // sum resolution + error
  baud_reg_val /= 1024; // divide by resolution  
  
  USART0.BAUD  = (unsigned short)baud_reg_val;
  USART0.CTRLA = 0b10000000; // Receive complete interrupt enable
  USART0.CTRLB = 0b11000000; // Receiver and transmitter enabled
  // CMODE Asynchronous Mode; UCPHA enabled; UDORD disabled; CHSIZE Character size: 8 bit; PMODE No Parity; SBMODE 1 stop bit; 
  USART0.CTRLC = 0x3;
  USART0.DBGCTRL = 1;
  
  USART_PORT.OUTSET = 1 << USART_TX_PIN;
  USART_PORT.DIRSET = 1 << USART_TX_PIN;
  USART_PORT.USART_RXPINCTRL = 8; // pullup enable
}

void usart_putchar(char c)
{
  while (!(USART0.STATUS & USART_DREIF_bm))
    ;
  USART0.TXDATAL = c;
}

int usart_fputchar(char c, FILE *stream)
{
  if (c == '\n')
    usart_putchar('\r');
  usart_putchar(c);
  return 0;
}
#endif

void
SystemInit (void)
{
  _PROTECTED_WRITE(CLKCTRL.MCLKCTRLB, 7); //prescaler enabled, division = 16
  InitPorts ();
  InitRTC ();
  InitI2C ();
  InitVREF();
  InitDAC1();
  InitComparator1();
  InitADC0();
  InitPWM();
#ifdef USART_ENABLED
  InitUsart();
#endif

  sleep_enable ();
  set_sleep_mode (SLEEP_MODE_IDLE);
}

unsigned short get_vbat(void)
{
  ADC0.COMMAND = ADC_STCONV_bm;
  while (!(ADC0.INTFLAGS & ADC_RESRDY_bm))
    ;
  return ADC0.RES;
}

void enable_pwm(void)
{
  CPU_CCP = CCP_IOREG_gc;    
  TCD0.FAULTCTRL = TCD_CMPAEN_bm; // Enable Compare A pin/channel for PWM
  TCD0.CTRLA = 1; // enabled, clock = 16 MHz
}

void disable_pwm(void)
{
  CPU_CCP = CCP_IOREG_gc;    
  TCD0.FAULTCTRL = 0; // Disable Compare A pin/channel for PWM
  TCD0.CTRLA = 0; // disabled
}

void pwm_set_duty(unsigned short value)
{
  if (!value && TCD0.CTRLA != 0)
    disable_pwm();
  TCD0.CMPACLR = value;
  TCD0.CTRLE   = 1; // SYNCEOC
  if (value && TCD0.CTRLA == 0)
    enable_pwm();
}

void dac_set(unsigned char value)
{
  DAC1.DATA = value;
}

int i2c_pcf8563_write(const unsigned char *data, int data_length)
{
  return TWI_sendMessage (PCF8563_I2C_ADDRESS, data, data_length);
}

int i2c_pcf8563_transfer(const unsigned char *wdata, int wdata_length, unsigned char *rdata, int rdata_length)
{
  return TWI_transfer(PCF8563_I2C_ADDRESS, wdata, wdata_length, rdata, rdata_length);
}
