#include "board.h"
#include <segment_lcd.h>
#include <avr/sleep.h>
#include <avr/interrupt.h>
#include <avr/wdt.h>

#define COEF1 19418

unsigned volatile char counter;
unsigned volatile char start_measurements;

ISR(RTC_OVF_vect)
{
    wdt_reset();
    SegmentLcdRefresh();
    if (counter == MEASUREMENT_PERIOD - 1)
    {
        counter = 0;
        start_measurements = 1;
    }
    else
        counter++;
}

int main(void) {
    unsigned char lcd_data[6];
    unsigned long v;
    
    HALInit();
    
    SegmentLcdInit();

    counter = start_measurements = 0;
    
    /*lcd_data[0] = 0x80 + '1';
    lcd_data[1] = '2';
    lcd_data[2] = '3';
    lcd_data[3] = '4';
    lcd_data[4] = '5';
    lcd_data[5] = 0;
    SegmentLcdPuts(lcd_data);*/
    
    sei();
    
    while (1) {
        sleep_cpu();
        if (start_measurements)
        {
            start_measurements = 0;
            ADCA.CH0.CTRL |= 0x80; // start ch0 conversion
            // todo wait for conversion to complete
            v = (ADCA.CH0.RES * 10000) / COEF1;
            lcd_data[4] = (v % 10) + '0';
            v /= 10;
            lcd_data[3] = (v % 10) + '0';
            v /= 10;
            lcd_data[2] = (v % 10) + '0';
            v /= 10;
            lcd_data[1] = (v % 10) + '0';
            v /= 10;
            lcd_data[0] = v + '0';
            lcd_data[5] = 0;
            SegmentLcdPuts(lcd_data);
        }
    }
}
