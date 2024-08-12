#include "board.h"
#include <segment_lcd.h>

#define MAX_CHARS_IN_LINE 5
#define CHAR_COUNT 10

#define L SEGMENT_LCD_DATA_WIDTH  * SEGMENT_LCD_COM_COUNT * MAX_CHARS_IN_LINE

static const char lcd_char_table[CHAR_COUNT][L] = 
{
    // A = byte 1 bit 
    // 0
    {
        // position 0
        0,1,0,1, // com0
        0,3,0,3, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 1
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 2
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 3
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 4
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
    },
    // 1
    {
        // position 0
        0,0,0,1, // com0
        0,2,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 1
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 2
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 3
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 4
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
    },
    // 2
    {
        // position 0
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 1
        0,0xC,0xC0,0, // com0
        0,4,0x40,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 2
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 3
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 4
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
    },
    // 3
    {
        // position 0
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 1
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 2
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 3
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 4
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
    },
    // 4
    {
        // position 0
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 1
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 2
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 3
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 4
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
    },
    // 5
    {
        // position 0
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 1
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 2
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 3
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 4
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
    },
    // 6
    {
        // position 0
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 1
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 2
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 3
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 4
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
    },
    // 7
    {
        // position 0
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 1
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 2
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 3
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 4
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
    },
    // 8
    {
        // position 0
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 1
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 2
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 3
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 4
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
    },
    // 9
    {
        // position 0
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 1
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 2
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 3
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
        // position 4
        0,0,0,0, // com0
        0,0,0,0, // com1
        0,0,0,0, // com2
        0,0,0,0, // com3
    }
};
    
void SegmentLcdBuildCharData(unsigned char c, unsigned char pos, unsigned char com, unsigned char *segment_lcd_data)
{
    unsigned char i, *p, point;
    
    point = c & 0x80;
    c &= 0x7F;
    
    if (c >= '0' && c <= '9')
    {
        c -= '0';
    }
    else
        return;
    
    pos *= SEGMENT_LCD_COM_COUNT * SEGMENT_LCD_DATA_WIDTH;
    pos += com * SEGMENT_LCD_DATA_WIDTH;
    p = &lcd_char_table[c][pos];
    
    for (i = 0; i < SEGMENT_LCD_DATA_WIDTH; i++)
    {
        c = *segment_lcd_data;
        c |= *p++;
        if (point && i == 1)
        {
            switch (pos)
            {
                case 12:
                    c |= 2; // PC1
                    break;
                case 28:
                    c |= 8; // PC3
                    break;
                case 44:
                    c |= 0x20; // PC5
                    break;
                case 60:
                    c |= 0x80; // PC7
                    break;
            }
        }
        *segment_lcd_data++ = c;
    }
}
