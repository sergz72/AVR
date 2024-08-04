#include "hal.h"
#include <avr/io.h>
#include <avr/sleep.h>

// PB0 - AC1_AINP2,AC2_AINP1
// PA2 - SW1
// PA3 - SW2
// PA4 - SW3
// PA5 - SW4
// PA6 - PULSE
// PA7 - LUT1-OUT (HI-Z)
// PB3 - AC1 OUT (1)
// PB2 - AC2 OUT (0)

static void InitPorts(void)
{
    PORTA.PIN0CTRL = 0x08; // Pull-up enable
    PORTA.PIN1CTRL = 0x08; // Pull-up enable
    PORTA.PIN2CTRL = 0x08; // Pull-up enable
    PORTA.PIN3CTRL = 0x08; // Pull-up enable
    PORTA.PIN4CTRL = 0x08; // Pull-up enable
    PORTA.PIN5CTRL = 0x08; // Pull-up enable
    PORTB.PIN1CTRL = 0x08; // Pull-up enable

    PORTA.OUTSET = 0x40; // SET PA6 to 1
    PORTA.DIR = 0x40; // PA6 - output
}

static void InitRTC(void)
{
    RTC.INTCTRL = 0x01; // OVF Interrupt enable
    RTC.PERL = 128; // 256 Hz interrupt
    while (RTC.STATUS)
        ;
    RTC.PERH = 0;   // 256 Hz interrupt
    while (RTC.STATUS)
        ;
    RTC.CLKSEL = 0x00; // 32768 Hz clock
    RTC.CTRLA = 0x01; // RTC enabled, no prescaling
}

static void InitDAC1(void)
{
    switch (PORTA.IN & 0x0C) // pin 2 & 3
    {
        case 0:
            DAC1.DATA = 123; // ~1.2v
            break;
        case 0x04:
            DAC1.DATA = 163; // ~1.6v
            break;
        case 0x08:
            DAC1.DATA = 204; // ~2.0v
            break;
        case 0x0C:
            DAC1.DATA = 245; // ~2.4v
            break;
    }
    DAC1.CTRLA = 0x01; // DAC enable
}

static void InitDAC2(void)
{
    switch (PORTA.IN & 0x30) // pin 4 & 5
    {
        case 0:
            DAC2.DATA = 47; // ~0.1v
            break;
        case 0x04:
            DAC2.DATA = 93; // ~0.2v
            break;
        case 0x08:
            DAC2.DATA = 139; // ~0.3v
            break;
        case 0x0C:
            DAC2.DATA = 187; // ~0.4v
            break;
    }
    DAC2.CTRLA = 0x01; // DAC enable
}

static void InitComparator1(void)
{
    AC1.MUXCTRLA = 0x93; // invert output, positive input - AINP2, negative input - DAC
    AC1.INTCTRL = 1;  // interrupt enable
    AC1.CTRLA = 0x61; // Comparator enable, output enable,
                      // INTMODE = negative edge
}

static void InitComparator2(void)
{
    AC2.MUXCTRLA = 0x0B; // not invert output, positive input - AINP1, negative input - DAC
    AC2.CTRLA = 0x41; // Comparator enable, output enable
}

static void InitCCL(void)
{
    CCL.SEQCTRL0 = 0; // Sequential logic is disabled
    CCL.LUT1CTRLB = 0xEC; //AC1 as input 0, AC2 as input 1
    CCL.LUT1CTRLC = 0; //input 2 is masked input
    CCL.TRUTH1 = 0x77; //01110111
    CCL.LUT1CTRLA = 0x09; // output is enabled, LUT is enabled
    CCL.CTRLA = 0x01; // Enable
}

static void InitVREF(void)
{
    VREF.CTRLC = 2; // DAC1 reference = 2.5v
    VREF.CTRLD = 0; // DAC2 reference = 0.55v
    VREF.CTRLB = 0x28; // Enable references for DAC1, DAC2
}

void HALInit(void)
{
    InitVREF();
    InitPorts();
    // pull up resistors are about 60k, RC delay with C = 100pf ~10us
    for (int i = 0; i < 200; i++)
        ;
    InitDAC1();
    InitDAC2();
    InitComparator1();
    InitComparator2();
    InitCCL();
    InitRTC();
            
    sleep_enable();
    set_sleep_mode(SLEEP_MODE_IDLE);
}
