#include "board.h"
#include "rtc_handler.h"
#include "sun_times.h"
#include <avr/sleep.h>
#include <rtc_pcf8563.h>

static rtc_data rdata;
static pcf8563_alarm adata;

static void halt(void)
{
  set_sleep_mode (SLEEP_MODE_PWR_DOWN);
  while (1)
  {
    sleep_cpu();
    LED_BATTERY_TOGGLE;
  }
}

void rtc_handler_init(void)
{
  adata.wday.enabled   = false;
  adata.wday.value = 0;
  adata.day.enabled    = false;
  adata.day.value = 1;
  adata.hour.enabled   = true;
  adata.minute.enabled = true;
}

#ifdef DEBUG_ENABLED
static bool on = false;

static void debug_rtc_handler(void)
{
  unsigned char minute = rdata.minutes + 1;
  unsigned char hour   = rdata.hours;
  if (minute > 59)
  {
    minute -= 60;
    hour++;
  }
  adata.hour.value = hour;
  adata.minute.value = minute;
  if (pcf8563_set_alarm(&adata))
    halt();
  on = !on;
  if (on)
    enable_pwm();
  else
  {
    disable_pwm();
    set_sleep_mode (SLEEP_MODE_PWR_DOWN);
  }
}

#else
static void release_rtc_handler(void)
{
  const sun_time *st = &sun_times[rdata.yday];
  if (rdata.hours < st->down_hours) // OFF
  {
    disable_pwm();
    adata.hour.value = st->down_hours;
    adata.minute.value = st->down_minutes;
    if (pcf8563_set_alarm(&adata))
      halt();
    set_sleep_mode (SLEEP_MODE_PWR_DOWN);
    return;
  }
  adata.hour.value = st->rise_hours;
  adata.minute.value = st->rise_minutes;
  if (pcf8563_set_alarm(&adata))
    halt();
  enable_pwm();
}
#endif

void rtc_handler(void)
{
  set_sleep_mode (SLEEP_MODE_IDLE);

  if (pcf8563_cancel_alarm())
    halt();
  if (pcf8563_get(&rdata))
    halt();
#ifdef DEBUG_ENABLED
  debug_rtc_handler();
#else
  release_rtc_handler();
#endif  
}

