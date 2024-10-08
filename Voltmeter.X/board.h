#ifndef _BOARD_H
#define _BOARD_H

#include <avr/io.h>

#define SEGMENT_LCD_DATA_WIDTH 3
#define SEGMENT_LCD_COM_COUNT 4

//COM0=PC0
#define SEGMENT_LCD_COM0_SETZ PORTC.DIRCLR = 1 // PC0 off
#define SEGMENT_LCD_COM0_SET0 PORTC.OUTCLR = 1; PORTC.DIRSET = 1 // PC0 set to 0
#define SEGMENT_LCD_COM0_SET1 PORTC.OUTSET = 1; PORTC.DIRSET = 1 // PC0 set to 1

//COM1=PC1
#define SEGMENT_LCD_COM1_SETZ PORTC.DIRCLR = 2 // PC1 off
#define SEGMENT_LCD_COM1_SET0 PORTC.OUTCLR = 2; PORTC.DIRSET = 2 // PC1 set to 0
#define SEGMENT_LCD_COM1_SET1 PORTC.OUTSET = 2; PORTC.DIRSET = 2 // PC1 set to 1

//COM2=PC2
#define SEGMENT_LCD_COM2_SETZ PORTC.DIRCLR = 4 // PC2 off
#define SEGMENT_LCD_COM2_SET0 PORTC.OUTCLR = 4; PORTC.DIRSET = 4 // PC2 set to 0
#define SEGMENT_LCD_COM2_SET1 PORTC.OUTSET = 4; PORTC.DIRSET = 4 // PC2 set to 1

//COM3=PR1
#define SEGMENT_LCD_COM3_SETZ PORTR.DIRCLR = 2 // PR1 off
#define SEGMENT_LCD_COM3_SET0 PORTR.OUTCLR = 2; PORTR.DIRSET = 2 // PR1 set to 0
#define SEGMENT_LCD_COM3_SET1 PORTR.OUTSET = 2; PORTR.DIRSET = 2 // PR1 set to 1

#define BUTTON_PRESSED !(PORTA.IN & 4)

#define RC_PER_VALUE 3 // 1/341 second interrupt
#define MEASUREMENT_PERIOD 171 // measurements every 0.5 second

void HALInit(void);
unsigned short GetADCValue(unsigned char channel);

#endif
