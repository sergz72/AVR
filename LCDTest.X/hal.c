#include "board.h"
#include <avr/sleep.h>
#include <st7066.h>
/*
 * PA1 = D0
 * PA2 = D1
 * PA3 = D2
 * PA4 = D3
 * PA5 = D4
 * PA6 = D5
 * PA7 = D6
 * PB2 = D7
 * PB1 = RS
 * PB0 = E
 */
static void InitPorts(void)
{
    PORTB.PIN3CTRL = 0x08; // Pull-up enable

    PORTA.DIR = 0xFE; // PA1-PA7 - outputs
    PORTB.DIR = 0x07; // PB0-PB2 - outputs
}

void HALInit(void)
{
    CPU_CCP = CCP_IOREG_gc;
    CLKCTRL.MCLKCTRLB = 0; //no division
    CPU_CCP = CCP_IOREG_gc;
    CLKCTRL.MCLKCTRLA = 1; //32.768 kHz internal ultra low-power oscillator
    
    InitPorts();
            
    sleep_enable();
    set_sleep_mode(SLEEP_MODE_IDLE);
}

void ST7066_DATA_SET(unsigned int d)
{
    PORTA.OUT = (unsigned char*)(d << 1);
    if (d & 0x80)
        PORTB.OUTSET = 4;
    else
        PORTB.OUTCLR = 4;
}

void st7066delay(void)
{
}

void delayms(unsigned int ms)
{
  ms *= 10;
  while (ms--)
    ;
}
