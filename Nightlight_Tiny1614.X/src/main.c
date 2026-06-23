#include "board.h"
#include <avr/sleep.h>
#include <avr/interrupt.h>
#include "usart_handler.h"
#include "rtc_handler.h"
#include "vbat_handler.h"

static unsigned char timer_counter;

int main()
{
  SystemInit();

#ifdef USART_ENABLED
  usart_handler_init();
#endif
  timer_counter = 0;

  rtc_handler_init();
  vbat_handler_init();
  
  timer_interrupt = 0;
  rtc_interrupt = 1;
  
  sei();
    
  while (1)
  {
    sleep_cpu();
    if (timer_interrupt)
    {
      timer_interrupt = 0;
#ifdef USART_ENABLED
      usart_handler();
#endif
      if (timer_counter == 1000/RTC_INT_MS - 1)
      {
        timer_counter = 0;
#ifdef DEBUG_ENABLED
        LED_TIMER_TOGGLE;
#endif      
        vbat_handler();
      }
      else
        timer_counter++;
    }
#ifndef USART_ENABLED
    if (rtc_interrupt)
    {
      rtc_interrupt = 0;
      rtc_handler();
    }
#endif
  }
}
