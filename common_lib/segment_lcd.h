#ifndef _SEGMENT_LCD_H
#define _SEGMENT_LCD_H

void SegmentLcdInit(void);
void SegmentLcdRefresh(void);
void SetSegmentLcdData(const unsigned char *dp); // user defined
void SegmentLcdBuildCharData(unsigned char c, unsigned char pos, unsigned char com, unsigned char *segment_lcd_data); // user defined
void SegmentLcdPuts(const unsigned char *s);

#endif
