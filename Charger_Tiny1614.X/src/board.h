#ifndef OVENCONTROLUI_BOARD_H
#define OVENCONTROLUI_BOARD_H

#ifndef NULL
#define NULL 0
#endif

#define SSD1306_128_64
#define LCD_ORIENTATION LCD_ORIENTATION_LANDSCAPE

#include <lcd_ssd1306.h>

#define SSD1306_SWITCHCAPVCC
#define SH1106

#define LCD_PRINTF_BUFFER_LENGTH 30
#define DRAW_TEXT_MAX 20
#define USE_VSNPRINTF

#define KB_UP 0x1E
#define KB_DOWN 0x1D
#define KB_SELECT 0x1B
#define KB_ENTER 0x17
#define KB_EXIT 0x0F

#define MAX_PROGRAM_ITEMS 5
#define MAX_PROGRAMS 4
#define MAX_CURRENT 2000
#define MAX_VOLTAGE 5000

#define RTC_INT_MS 50

#define TIMER_DELAY 250

#define CLK_PER 10000
#define F_SCL 100

#define LED_PORT PORTB
#define LED_PIN 2

void delayms(unsigned int ms);
void SystemInit(void);
unsigned int get_keyboard_status(void);
int get_lcd_buffer_bit(int x, int y);
unsigned int get_voltage(void);
void set_current(int mA);
void save_data(void *p, unsigned int size);
void load_data(void *p, unsigned int size);

#endif
