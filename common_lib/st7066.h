#ifndef _ST7066_H
#define _ST7066_H

#define ST7066_ENTRY_MODE_ADDRESS_INCREMENT 2 // DDRAM address increment
#define ST7066_ENTRY_MODE_SHIFT_DISPLAY     1 // Shift of entire display
#define ST7066_DISPLAY_ON                   4
#define ST7066_CURSOR_ON                    2
#define ST7066_BLINK_ON                     1
#define ST7066_SHIFT_DISPLAY                8
#define ST7066_SHIFT_RIGHT                  4
#define ST7066_FUNCTION_N                   8
#define ST7066_FUNCTION_F                   4

void st7066_init(unsigned char num_rows, unsigned char mode);
void st7066_clear_display(unsigned char wait);
void st7066_return_home(void);
void st7066_entry_mode(unsigned char mode);
void st7066_display_control(unsigned char dcb);
void st7066_shift(unsigned char scrl);
void st7066_function_set(unsigned char nf);
void st7066_set_ddram_address(unsigned char address);
void st7066_write_data(unsigned char data);

#endif
