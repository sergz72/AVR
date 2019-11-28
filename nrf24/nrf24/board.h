#ifndef BOARD_H 
#define BOARD_H

#include <avr/io.h>

// clr PB1
#define ST7066_RS_CLR PORTB.OUTCLR = 2
// set PB1
#define ST7066_RS_SET PORTB.OUTSET = 2

// clr PB0
#define ST7066_E_CLR PORTB.OUTCLR = 1
// set PB0
#define ST7066_E_SET PORTB.OUTSET = 1

#define ST7066_DATA_SET(d) PORTA.OUT = d

//#define ST7066_DELAY delay(1)
#define ST7066_DELAY
#define ST7066_DELAY_MS(ms) delayms(ms)

#define SENSOR_UPDATE_PERIOD 300

#define nRF24_CE_CLR PORTD.OUTCLR = 4
#define nRF24_CE_SET PORTD.OUTSET = 4
#define nRF24_CSN_CLR PORTD.OUTCLR = 0x10
#define nRF24_CSN_SET PORTD.OUTSET = 0x10
#define nRF24_IRQ PORTD.IN & 8

unsigned char nRF24_RW(unsigned char data);

void delayms(unsigned int ms);
void delay(unsigned int us);

#endif //#ifndef BOARD_H
