#ifndef _BOARD_H
#define _BOARD_H

#include <avr/io.h>

// clr PB1
#define ST7066_RS_CLR PORTB.OUTCLR = 2
// set PB1
#define ST7066_RS_SET PORTB.OUTSET = 2

// clr PB0
#define ST7066_E_CLR PORTB.OUTCLR = 1
// set PB0
#define ST7066_E_SET PORTB.OUTSET = 1

void ST7066_DATA_SET(unsigned int d);
#define ST7066_DELAY st7066delay()
#define ST7066_DELAY_MS(ms) delayms(ms)

void delayms(unsigned int);
void st7066delay(void);

void HALInit(void);

#endif
