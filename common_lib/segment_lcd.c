#include <board.h>
#include <segment_lcd.h>
#include <string.h>

static unsigned char segment_lcd_data[SEGMENT_LCD_COM_COUNT][SEGMENT_LCD_DATA_WIDTH];
static unsigned char segment_lcd_state;

void SegmentLcdInit(void)
{
    memset(segment_lcd_data, 0, sizeof(segment_lcd_data));
    segment_lcd_state = 0;
}

void SegmentLcdRefresh(void)
{
    unsigned char data_index = segment_lcd_state >> 1;
    unsigned char data[SEGMENT_LCD_DATA_WIDTH];
    unsigned char i;
    
    SetSegmentLcdData(NULL); // all segments off
    switch (segment_lcd_state)
    {
        case 0:
            SEGMENT_LCD_COM1_SETZ;
            SEGMENT_LCD_COM2_SETZ;
            SEGMENT_LCD_COM3_SETZ;
            SEGMENT_LCD_COM0_SET0;
            break;
        case 1:
            SEGMENT_LCD_COM0_SET1;
            break;
        case 2:
            SEGMENT_LCD_COM0_SETZ;
            SEGMENT_LCD_COM1_SET0;
            break;
        case 3:
            SEGMENT_LCD_COM1_SET1;
            break;
        case 4:
            SEGMENT_LCD_COM1_SETZ;
            SEGMENT_LCD_COM2_SET0;
            break;
        case 5:
            SEGMENT_LCD_COM2_SET1;
            break;
        case 6:
            SEGMENT_LCD_COM2_SETZ;
            SEGMENT_LCD_COM3_SET0;
            break;
        case 7:
            SEGMENT_LCD_COM3_SET1;
            break;
        default:
            SEGMENT_LCD_COM0_SETZ;
            SEGMENT_LCD_COM1_SETZ;
            SEGMENT_LCD_COM2_SETZ;
            SEGMENT_LCD_COM3_SETZ;
            break;
    }

    if (segment_lcd_state & 1)
    {
        for (i = 0; i < SEGMENT_LCD_DATA_WIDTH; i++)
            data[i] = segment_lcd_data[data_index][i] ^ 0xFF;
        SetSegmentLcdData(data);
    }
    else
        SetSegmentLcdData(segment_lcd_data[data_index]);

    if (segment_lcd_state == SEGMENT_LCD_COM_COUNT * 2 - 1)
        segment_lcd_state = 0;
    else
        segment_lcd_state++;
}

void SegmentLcdPuts(const unsigned char *s)
{
    unsigned char c, i, pos;
    
    memset(segment_lcd_data, 0, sizeof(segment_lcd_data));

    pos = 0;
    for (;;)
    {
        c = *s++;
        if (!c)
            break;
        for (i = 0; i < SEGMENT_LCD_COM_COUNT; i++)
            SegmentLcdBuildCharData(c, pos, i, segment_lcd_data[i]);
        pos++;
    }
}