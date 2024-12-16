#include <stdio.h>
#include <string.h>
#include "board.h"
#include "battery_emulator.h"

#define SIZE (LCD_HWHEIGHT * LCD_HWWIDTH / 8)

extern int keyboard_state;
extern int exit_delay;
extern int exit_long_press;
static unsigned char lcd_buffer[SIZE], *lcd_buffer_p = lcd_buffer;
static unsigned int current = 0;

void delayms(unsigned int ms)
{
}

int SSD1306_I2C_Write(int num_bytes, unsigned char control_byte, unsigned char *buffer)
{
  if (control_byte == 0x40)
  {
    memcpy(lcd_buffer_p, buffer, num_bytes);
    lcd_buffer_p += num_bytes;
    if (lcd_buffer_p - lcd_buffer >= SIZE)
      lcd_buffer_p = lcd_buffer;
  }
  return 0;
}

unsigned int get_keyboard_status(void)
{
  unsigned int state = keyboard_state;
  if (exit_delay)
  {
    exit_delay--;
    if (!exit_delay)
    {
      state = exit_long_press ? KB_EXIT_LONG : KB_EXIT;
      exit_long_press = 0;
    }
  }
  keyboard_state = 0x1F;
  return state;
}

unsigned int get_voltage(void)
{
  return get_next_voltage(TIMER_DELAY, current);
}

void set_current(int mA)
{
  current = mA;
}

void save_data(void *p, unsigned int size)
{
  auto f = fopen("data.bin", "wb");
  if (f != NULL)
  {
    fwrite(p, size, 1, f);
    fclose(f);
  }
}

void load_data(void *p, unsigned int size)
{
  auto f = fopen("data.bin", "rb");
  if (f != NULL)
  {
    fread(p, size, 1, f);
    fclose(f);
  }
}

int get_lcd_buffer_bit(int x, int y)
{
  unsigned char *p = lcd_buffer + x + (y >> 3U) * LCD_WIDTH;
  int bit = y & 7;
  return *p & (1 << bit);
}
