#include "board.h"
#include "vbat_handler.h"
#include <avr/io.h>

static char vbat_alert;

void vbat_handler_init(void)
{
  vbat_alert = 0;
}

void vbat_handler(void)
{
  unsigned int vbat = get_vbat();
  if (!vbat_alert)
  {
    if (vbat > VBAT_3V0)
    {
      vbat_alert = 1;
      LED_BATTERY_ON;
    }
  }
  else
  {
    if (vbat < VBAT_3V2)
    {
      vbat_alert = 0;
      LED_BATTERY_OFF;
    }
  }
}

