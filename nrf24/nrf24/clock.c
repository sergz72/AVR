#include "board.h"
#include "clock.h"
#include <st7066.h>
#include <avr/interrupt.h>

unsigned char seconds, minutes, hours, update_hours, update_minutes;
volatile unsigned char update_clock;

ISR(RTC_OVF_vect)
{
  update_clock = 1;
}

void clock_init(void)
{
  seconds = minutes = hours = 0;
  update_hours = update_minutes = update_clock = 1;
}

unsigned char clock_proc(void)
{
  unsigned char v;
  
  if (update_clock)
  {
    if (seconds == 59)
    {
      seconds = 0;
      if (minutes == 59)
      {
        minutes = 0;
        if (hours == 23)
          hours = 0;
        else
          hours++;
        update_hours = 1;
      }
      else
        minutes++;
      update_minutes = 1;
    }
    else
      seconds++;

    if (update_hours)
    {
      st7066_set_ddram_address(0);
      v = hours / 10;
      if (!v)
        st7066_write_data(' ');
      else
        st7066_write_data('0' + v);
      v = hours % 10;
      st7066_write_data('0' + v);
    }
    else
    st7066_set_ddram_address(2);
    st7066_write_data(seconds & 1U ? ':' : ' ');
    if (update_minutes)
    {
      v = minutes / 10;
      st7066_write_data('0' + v);
      v = minutes % 10;
      st7066_write_data('0' + v);
    }

    update_hours = update_minutes = update_clock = 0;
    return 1;
  }
  return 0;
}