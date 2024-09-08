#include "board.h"
#include <segment_lcd.h>
#include <avr/sleep.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>

#define RTC_Busy()               ( RTC.STATUS & RTC_SYNCBUSY_bm )

static volatile unsigned char adc_done;
static volatile unsigned short adc_result;

#define OFFSET 2560

ISR(ADCA_CH0_vect)
{
    adc_done = 1;
    adc_result = ADCA.CH0.RES - OFFSET;
}

unsigned short GetADCValue(unsigned char channel)
{
    adc_done = 0;
    ADCA.CH0.MUXCTRL = channel << 3;
    ADCA.CH0.CTRL |= 0x80; // start conversion
    // wait for conversion to complete
    while (!adc_done)
        sleep_cpu();
    return adc_result;
}

static void InitRTC(void)
{
    do {
    /* Wait until RTC is not busy. */
    } while (RTC_Busy());
    
    RTC.PER = RC_PER_VALUE;
    RTC.CTRL = 1; // no prescaler
    RTC.INTCTRL = RTC_OVFINTLVL_HI_gc;
    CLK.RTCCTRL = 0x05; //RTC Clock Source Enable - 1.024kHz from 32.768kHz internal oscillator
}

static void InitADC(void)
{
    // High current limit, max. sampling rate 75kSPS
    // More than 12-bit right adjusted result, then oversampling or averaging is used (SAPNUM>0)
    ADCA.CTRLB = 0b01100010;
    //ADCA.CTRLB = 0b01100000;
    ADCA.REFCTRL = 0b00100000; // VREF = External reference from AREF on port A
    ADCA.PRESCALER = 0; // DIV4
    ADCA.SAMPCTRL = 0x3F; // maximum sampling time
    ADCA.CH0.CTRL = 1; // single ended
    ADCA.CH0.INTCTRL = 1; // low level interrupt
    ADCA.CH0.AVGCTRL = 8; //256 samples, 16 bit resolution
    ADCA.CAL = 250;
    ADCA.CAL = 250;
    
    ADCA.CTRLA = 1; // enable ADC
}

static void InitWDT(void)
{
    CCP = CCP_IOREG_gc;
    WDT.CTRL = 0x27; // 4s timeout 
}

/*
 * COM0=PC0
 * COM1=PC1
 * COM2=PC2
 * COM3=PR1
 * SEG12=PR0
 * SEG11=PD7
 * SEG10=PD6
 * SEG9=PD5
 * SEG8=PD4
 * SEG7=PD3
 * SEG6=PD2
 * SEG5=PD1
 * SEG4=PA5
 * SEG3=PA6
 * SEG2=PA7
 * SEG1=PD0
 *
 * BUTTON=PA2
 *
 * Resistance_MEASUREMENT=PA3
 * Voltage measurement = PA4 
 *
 * Voltage coefficient switch = PA1
 * Resistance Coefficients switches = PC3-PC7
 * 
 * VREF = PA0
*/

static void InitPorts()
{
    PORTA.PIN0CTRL = 0x07; // Digital input buffer disabled
    PORTA.PIN1CTRL = 0x07; // Digital input buffer disabled
    PORTA.PIN2CTRL = 0x18; // Pull-up enable
    PORTA.PIN3CTRL = 0x07; // Digital input buffer disabled
    PORTA.PIN4CTRL = 0x07; // Digital input buffer disabled

    PORTC.PIN3CTRL = 0x07; // Digital input buffer disabled
    PORTC.PIN4CTRL = 0x07; // Digital input buffer disabled
    PORTC.PIN5CTRL = 0x07; // Digital input buffer disabled
    PORTC.PIN6CTRL = 0x07; // Digital input buffer disabled
    PORTC.PIN7CTRL = 0x07; // Digital input buffer disabled
}

void HALInit(void)
{
    OSC.CTRL = 5; // Enable RC32K
    while (!(OSC.STATUS & 4)); // Wait for RC32K to stabilize
  
    CCP = CCP_IOREG_gc;
    //CLK.CTRL = 1;
    // clkper4 = clkper2 = clkper = clkcpu = 2M / 8 = 250 kHz
    CLK.PSCTRL = 5 << 2;

    InitPorts();
    InitRTC();
    InitADC();

    // enable interrupts
    PMIC.CTRL = 7;

    //InitWDT();
    
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
