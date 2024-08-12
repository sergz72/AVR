#include "board.h"
#include <segment_lcd.h>
#include <avr/sleep.h>

#define RTC_Busy()               ( RTC.STATUS & RTC_SYNCBUSY_bm )

void HALInit(void)
{
    OSC.CTRL = 5; // Enable RC32K
    while (!(OSC.STATUS & 4)); // Wait for RC32K to stabilize
  
    CCP = CCP_IOREG_gc;
    // clkper4 = clkper2 = clkper = clkcpu = 2M / 4 = 500 kHz
    CLK.PSCTRL = 3 << 2;
  
    do {
    /* Wait until RTC is not busy. */
    } while (RTC_Busy());
    
    RTC.PER = 3; // 1/341 second interrupt
    RTC.CTRL = 1; // no prescaler
    RTC.INTCTRL = RTC_OVFINTLVL_LO_gc;
    CLK.RTCCTRL = 0x05; //RTC Clock Source Enable - 1.024kHz from 32.768kHz internal oscillator

    PMIC.CTRL = 7;

    //CCP = CCP_IOREG_gc;
    //WDT.CTRL = 0x27; // 4s timeout 
    
    sleep_enable();
    set_sleep_mode(SLEEP_MODE_IDLE);    
}

void SetSegmentLcdData(const unsigned char *dp)
{
    unsigned char c;
    
    if (!dp)
    {
        PORTA.DIRCLR = 3; // only PA1, PA0
        PORTC.DIRCLR = 0xFF;
        PORTD.DIRCLR = 0xFF;
        PORTR.DIRCLR = 3;
        return;
    }
    c = (*dp++) & 3;
    PORTA.OUTCLR = c ^ 3;
    PORTA.OUTSET = c;
    PORTC.OUT = *dp++;
    PORTD.OUT = *dp++;
    PORTR.OUT = *dp;
    PORTA.DIRSET = 3;
    PORTC.DIRSET = 0xFF;
    PORTD.DIRSET = 0xFF;
    PORTR.DIRSET = 3;
}
