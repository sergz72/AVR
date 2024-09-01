#include "board.h"
#include <segment_lcd.h>
#include <avr/sleep.h>

#define RTC_Busy()               ( RTC.STATUS & RTC_SYNCBUSY_bm )

/*
COM0=PC0
COM1=PC1
COM2=PC2
COM3=PR1
SEG12=PR0
SEG11=PD7
SEG10=PD6
SEG9=PD5
SEG8=PD4
SEG7=PD3
SEG6=PD2
SEG5=PD1
SEG4=PA5
SEG3=PA6
SEG2=PA7
SEG1=PD0
*/

void HALInit(void)
{
    OSC.CTRL = 5; // Enable RC32K
    while (!(OSC.STATUS & 4)); // Wait for RC32K to stabilize
  
    CCP = CCP_IOREG_gc;
    // clkper4 = clkper2 = clkper = clkcpu = 2M / 8 = 250 kHz
    CLK.PSCTRL = 5 << 2;
  
    do {
    /* Wait until RTC is not busy. */
    } while (RTC_Busy());
    
    RTC.PER = RC_PER_VALUE;
    RTC.CTRL = 1; // no prescaler
    RTC.INTCTRL = RTC_OVFINTLVL_LO_gc;
    CLK.RTCCTRL = 0x05; //RTC Clock Source Enable - 1.024kHz from 32.768kHz internal oscillator

    // High current limit, max. sampling rate 75kSPS
    // More than 12-bit right adjusted result, then oversampling or averaging is used (SAPNUM>0)
    ADCA.CTRLB = 0b01100010;
    ADCA.REFCTRL = 0b00010010; // VREF = AVCC/1.6, bandgap enable
    ADCA.PRESCALER = 0; // DIV4
    ADCA.SAMPCTRL = 0x3F; // maximum samplimng time
    ADCA.CH0.CTRL = 1; // single ended
    ADCA.CH0.MUXCTRL = 4 << 3; // channel 4
    ADCA.CH0.AVGCTRL = 8; //256 samples, 16 bit resolution
    
    ADCA.CTRLA = 1; // enable ADC
    
    PMIC.CTRL = 7;

    //CCP = CCP_IOREG_gc;
    //WDT.CTRL = 0x27; // 4s timeout 
    
    sleep_enable();
    set_sleep_mode(SLEEP_MODE_IDLE);    
}

/*
SEG12=PR0
SEG11=PD7
SEG10=PD6
SEG9=PD5
SEG8=PD4
SEG7=PD3
SEG6=PD2
SEG5=PD1
SEG4=PA5
SEG3=PA6
SEG2=PA7
SEG1=PD0
*/

void SetSegmentLcdData(const unsigned char *dp)
{
    unsigned char c;
    
    if (!dp)
    {
        PORTA.DIRCLR = 0xE0; // PA5,6,7
        PORTD.DIRCLR = 0xFF;
        PORTR.DIRCLR = 1;
        return;
    }
    c = *dp++;
    PORTA.OUTCLR = c ^ 0xE0;
    PORTA.OUTSET = c;
    PORTD.OUT = *dp++;
    c = *dp;
    PORTR.OUTCLR = c ^ 1;
    PORTR.OUTSET = c;
    PORTA.DIRSET = 0xE0;
    PORTD.DIRSET = 0xFF;
    PORTR.DIRSET = 1;
}
