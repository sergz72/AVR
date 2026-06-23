#include "board.h"
#include "usart_handler.h"
#include <rtc_pcf8563.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef USART_ENABLED
volatile char command_line[COMMMAND_LINE_SIZE];
volatile char *command_line_p, *command_line_echo_p;
volatile int command_ready;

void usart_interrupt_handler(unsigned char c)
{
  if (command_ready)
      return;
  if (c == '\r')
      command_ready = 1;
  else
      *command_line_p++ = c;
}

void usart_handler_init(void)
{
  command_line_p = command_line;
  command_line_echo_p = command_line;
  command_ready = 0;
}

static void run_command(void)
{
  size_t l = strlen((const char*)command_line);
  switch (l)
  {
  case 4:
    if (!strcmp((const char*)command_line, "vbat"))
    {
      unsigned int vbat_value = get_vbat();
      printf("vbat=%d\n", vbat_value);
      return;
    }
    if (!strcmp((const char*)command_line, "date"))
    {
      rtc_data rdata;
      int rc = pcf8563_get(&rdata);
      if (rc != 0)
        printf("rc=%d\n", rc);
      else
        printf("Date: %d.%02d.%04d %02d:%02d:%02d weekday=%d yday=%d\n", rdata.day, rdata.month, rdata.year, rdata.hours,
               rdata.minutes, rdata.seconds, rdata.wday, rdata.yday);
      return;
    }
    break;
  case 6:
    if (!strcmp((const char*)command_line, "pwm on"))
    {
      enable_pwm();
      puts("Ok");
      return;
    }
    break;
  case 7:
    if (!strcmp((const char*)command_line, "pwm off"))
    {
      disable_pwm();
      puts("Ok");
      return;
    }
    break;
  default:
    break;
  }
  if (l > 4 && !strncmp((const char*)command_line, "pwm ", 4))
  {
    int value = atoi((const char*)command_line + 4);
    if (value < 0 || value >= PWM_CMP_CALC(OSC20M_FREQUENCY))
      puts("wrong value");
    else
    {
      pwm_set_duty((unsigned short)value);
      puts("Ok");
    }
    return;
  }
  if (l > 4 && !strncmp((const char*)command_line, "dac ", 4))
  {
    int value = atoi((const char*)command_line + 4);
    if (value < 0 || value >= 255)
      puts("wrong value");
    else
    {
      dac_set((unsigned char)value);
      puts("Ok");
    }
    return;
  }
  if (l > 5 && !strncmp((const char*)command_line, "date ", 5))
  {
    //format: 202606221110
    unsigned long long int value = strtoull((const char*)command_line + 5, NULL, 10);
    unsigned char minutes = value % 100;
    value /= 100;
    unsigned char hours = value % 100;
    value /= 100;
    unsigned char day = value % 100;
    value /= 100;
    unsigned char month = value % 100;
    value /= 100;
    unsigned int year = value;
    if (value < 2026)
      puts("wrong value");
    else
    {
      int rc = pcf8563_set_datetime(year, month, day, hours, minutes, 0);
      if (rc)
        printf("rc=%d\n", rc);
      else
        puts("Ok");
    }
    return;
  }
  puts("unknown command\r");
}

static void usart_echo(void)
{
  while (command_line_echo_p != command_line_p)
    usart_putchar(*command_line_echo_p++);
}

void usart_handler(void)
{
  usart_echo();
  if (command_ready)
  {
    puts("\r");
    *command_line_p = 0;
    run_command();
    usart_handler_init();
  }
}
#endif
