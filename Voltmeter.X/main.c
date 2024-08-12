#include "board.h"
#include <segment_lcd.h>
#include <avr/sleep.h>
#include <avr/interrupt.h>
#include <avr/wdt.h>

ISR(RTC_OVF_vect)
{
    wdt_reset();
    SegmentLcdRefresh();
}

int main(void) {
    unsigned char lcd_data[6];
    HALInit();
    
    SegmentLcdInit();

    lcd_data[0] = 0x80 + '1';
    lcd_data[1] = '2';
    lcd_data[2] = '3';
    lcd_data[3] = '4';
    lcd_data[4] = '5';
    lcd_data[5] = 0;
    SegmentLcdPuts(lcd_data);
    
    sei();
    
    while (1) {
        sleep_cpu();
    }
}
