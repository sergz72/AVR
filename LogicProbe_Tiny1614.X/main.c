#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include "hal.h"

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

#define DELAY 26 // ~ 10Hz

volatile unsigned char delay;

// Analog comparator 1 interrupt
ISR(AC1_AC_vect)
{
    delay = DELAY;
    PORTA.OUTCLR = 0x40; // set PA6 to 0
    AC1.STATUS = AC_CMP_bm; // clear interrupt flag
}

// RTC counter interrupt
// PA6 - PULSE
ISR(RTC_CNT_vect)
{
    if (delay)
        delay--;
    else
        PORTA.OUTSET = 0x40; // set PA6 to 1
    RTC.INTFLAGS = 0x03; // clear interrupt flags
}

int main(void)
{
    HALInit();
    
    delay = 0;
    
    sei();

    while (1)
    {
        sleep_cpu();
    }
}
