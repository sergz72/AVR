#include "board.h"
#include <segment_lcd.h>
#include <avr/sleep.h>
#include <avr/interrupt.h>
#include <avr/wdt.h>

#define COEFV1 1248
#define COEFV2 10000

#define COEFR1 19418
#define COEFR2 10000
#define COEFR3 19418
#define COEFR4 10000
#define COEFR5 19418

#define MODE_R_MAX 60100 // 2.75v
#define MODE_R_MIN 13200 // 0.6v


#define NO_OVF 0
#define MODE_CHANGE 1
#define OVF 2

// 0-10v
#define MODE_V1 0
// 10-30v
#define MODE_V2 1

// < 1k
#define MODE_R1 2
// >= 1k
#define MODE_R2 3
// >= 10k
#define MODE_R3 4
// >= 100k
#define MODE_R4 5
// >= 1M
#define MODE_R5 6

//PA4
#define CHANNEL_V 4
//PA3
#define CHANNEL_R 3

unsigned volatile char counter;
unsigned volatile char start_measurements;

static unsigned char lcd_data[7];
static unsigned char mode;
static unsigned long coef;
static unsigned char channel;

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

static void SetMode()
{
    switch (mode)
    {
        case MODE_V1:
            channel = CHANNEL_V;
            coef = COEFV1;
            lcd_data[0] = 10; // U
            break;
        case MODE_V2:
            channel = CHANNEL_V;
            coef = COEFV2;
            lcd_data[0] = 10; // U
            break;
        case MODE_R1:
            channel = CHANNEL_R;
            coef = COEFR1;
            lcd_data[0] = 11; // o
            break;
        case MODE_R2:
            channel = CHANNEL_R;
            coef = COEFR2;
            lcd_data[0] = 11; // o
            break;
        case MODE_R3:
            channel = CHANNEL_R;
            coef = COEFR3;
            lcd_data[0] = 11; // o
            break;
        case MODE_R4:
            channel = CHANNEL_R;
            coef = COEFR4;
            lcd_data[0] = 12; // K
            break;
        case MODE_R5:
            channel = CHANNEL_R;
            coef = COEFR5;
            lcd_data[0] = 12; // K
            break;
        default:
            break;
    }
}

static unsigned long CalcV(unsigned short res)
{
    unsigned long v = res;
    if (v == 0xFFFF)
        return OVF;
    switch (mode)
    {
        case MODE_V1:
        case MODE_V2:
            v = v * 1000 / coef;
            break;
        default:
            v = ~v * 1000 / coef;
            break;
    }
    return v;
}

static void NextMode()
{
    if (mode < MODE_R1)
        mode = MODE_R5;
    else
        mode = MODE_V2;
    SetMode();
}

static unsigned char IsOVF(unsigned short res, unsigned long v)
{
    switch (mode)
    {
        case MODE_V1:
            if (v >= 100000)
            {
                mode = MODE_V2;
                SetMode();
                return MODE_CHANGE;
            }
            break;
        case MODE_V2:
            if (res == 0xFFFF)
                return OVF;
            if (v < 9900)
            {
                mode = MODE_V1;
                SetMode();
                return MODE_CHANGE;
            }
            break;
         case MODE_R1:
         case MODE_R2:
         case MODE_R3:
         case MODE_R4:
         case MODE_R5:
            if (res > MODE_R_MAX)
            {
                if (mode == MODE_R5)
                    return OVF;
                mode++;
                SetMode();
                return MODE_CHANGE;
            }
            if (res < MODE_R_MIN && mode > MODE_R1)
            {
                mode--;
                SetMode();
                return MODE_CHANGE;
            }
            break;
    }
    return NO_OVF;
}

static unsigned char GetPointPos()
{
    switch (mode)
    {
        // < 10v
        case MODE_V1:
        // < 10k
        case MODE_R2:
            return 1;
        // > 10v
        case MODE_V2:
        // < 100k
        case MODE_R3:
        // > 1M
        case MODE_R5:
            return 2;
        // < 1k
        case MODE_R1:
        // < 1M
        case MODE_R4:
            return 3;
        default:
            return 10;
    }
}

static void LcdTest(void)
{
    lcd_data[0] = 10; // U
    lcd_data[1] = 1;
    lcd_data[2] = 2;
    lcd_data[3] = 3;
    lcd_data[4] = 4;
    lcd_data[5] = 0x80 + 5;
    SegmentLcdPuts(lcd_data);
}

static void ProcessEvents(void)
{
    unsigned long v;
    unsigned short res;
    unsigned char rc, pointPos, c;

    if (start_measurements)
    {
        start_measurements = 0;
        if (BUTTON_PRESSED)
            NextMode();
        else
        {
            res = GetADCValue(channel);
            v = CalcV(res);
            rc = IsOVF(res, v);
            switch (rc)
            {
                case NO_OVF:
                    rc = 5;
                    pointPos = GetPointPos();
                    while (rc > 0)
                    {
                        if (v != 0)
                        {
                            c = v % 10;
                            v /= 10;
                        }
                        else if (rc < pointPos)
                            c = 14; // space
                        else
                            c = 0;
                        if (rc == pointPos)
                            c |= 0x80;
                        lcd_data[rc--] = c;
                    }
                    break;
                case OVF:
                    lcd_data[5] = 11;
                    lcd_data[4] = 11;
                    lcd_data[3] = 11;
                    lcd_data[2] = 11;
                    lcd_data[1] = 11;
                    break;
                default:
                    break;
            }
            SegmentLcdPuts(lcd_data);
        }
    }
}

int main(void)
{
    HALInit();
    
    SegmentLcdInit();

    counter = start_measurements = 0;
    lcd_data[6] = 0xFF;
    mode = MODE_V1;
    SetMode();

    sei();

    //GetADCValue(channel);
    
    //LcdTest();
        
    while (1) {
        sleep_cpu();
        ProcessEvents();
    }
}
