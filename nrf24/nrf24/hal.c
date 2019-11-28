#include "board.h"
#include "hal.h"
#include <nrf24.h>
#include <avr/cpufunc.h>

#define RTC_Busy()               ( RTC.STATUS & RTC_SYNCBUSY_bm )

#define SPI_TIMEOUT 0xFF

void HALInit(void)
{
  OSC.CTRL = 5; // Enable RC32K
  while (!(OSC.STATUS & 4)); // Wait for RC32K to stabilize
  
  CCP = CCP_IOREG_gc;
  CLK.PSCTRL = 0x1C; // clkper = 2M / 16
  
	do {
  	/* Wait until RTC is not busy. */
	} while (RTC_Busy());

  RTC.PER = 1023; // 1 second interrupt
  RTC.CTRL = 1; // no prescaler
  RTC.INTCTRL = RTC_OVFINTLVL_LO_gc;
  CLK.RTCCTRL = 5; //RTC Clock Source Enable - 1.024kHz from 32.768kHz internal oscillator

  SPID.CTRL = 0b11010000; // enable, MSB, master, mode 0, prescaler = ClkPER/2

  AES.CTRL = 0x20; //  soft reset
  
	/* Set SS output to high. (No slave addressed). */
	PORTD.OUTSET = PIN4_bm;

  PORTA.DIR = 0xFF; // all pins output
  PORTB.DIR = 3; // PB0, PB1 - output
  PORTC.DIR = 0;
  PORTD.DIR = 0b10110100; // SCK, MOSI, SS, CE
  PORTR.DIR = 0;

  // unused pin control
  // port B  
  PORTB.PIN2CTRL = 0x18; //pullup
  PORTB.PIN3CTRL = 0x18; //pullup
  // port C
  PORTC.PIN0CTRL = 0x18; //pullup
  PORTC.PIN1CTRL = 0x18; //pullup
  PORTC.PIN2CTRL = 0x18; //pullup
  PORTC.PIN3CTRL = 0x18; //pullup
  PORTC.PIN4CTRL = 0x18; //pullup
  PORTC.PIN5CTRL = 0x18; //pullup
  PORTC.PIN6CTRL = 0x18; //pullup
  PORTC.PIN7CTRL = 0x18; //pullup
  // port D
  PORTD.PIN0CTRL = 0x18; //pullup
  PORTD.PIN1CTRL = 0x18; //pullup
  //PORTD.PIN3CTRL = 2; //interrupt sense falling
  // port E
  PORTE.PIN0CTRL = 0x18; //pullup
  PORTE.PIN1CTRL = 0x18; //pullup
  PORTE.PIN2CTRL = 0x18; //pullup
  PORTE.PIN3CTRL = 0x18; //pullup
  // port R
  PORTR.PIN0CTRL = 0x18; //pullup
  PORTR.PIN1CTRL = 0x18; //pullup

  //PORTD.INTCTRL = PORT_INT0LVL_MED_gc;
  //PORTD.INT0MASK = 8; // PD3
  
  PMIC.CTRL = 7;
  
  CCP = CCP_IOREG_gc;
  WDT.CTRL = 0x27; // 4s timeout 
}

void delay(unsigned int us)
{
  unsigned int i;
  us >> 3;
  for (i = 0; i < us; i++)
    _NOP();
}

void delayms(unsigned int ms)
{
  unsigned int i;
  for (i = 0; i < ms; i++)
    delay(1000);
}

unsigned char nrf24_RW(unsigned char *txdata, unsigned char *rxdata, unsigned char size)
{
  unsigned char timeout;

  nRF24_CSN_CLR;
  
  while (size--)
  {
    SPID.DATA = *txdata++;
    timeout = SPI_TIMEOUT;
    /* Wait for transmission complete. */
    while(--timeout && !(SPID.STATUS & SPI_IF_bm))
    {}
    if (!timeout)
    {
      nRF24_CSN_SET;
      return 0;
    }      
    *rxdata++ = SPID.DATA;
  }    
  nRF24_CSN_SET;
  return 1;
}
