#include "board.h"
#include "sensor.h"
#include <st7066.h>

int temperature;
unsigned char humidity;
static int prev_temperature;
static unsigned char prev_humidity;
static unsigned int counter;

void sensor_init(void)
{
  temperature = prev_temperature = 0;
  humidity = prev_humidity = 0;
  counter = 0;

  st7066_set_ddram_address(8);
  st7066_write_data('I');
  st7066_write_data('n');
  st7066_set_ddram_address(0x40);
  st7066_write_data('H');
  st7066_write_data('u');
  st7066_write_data('m');
  st7066_set_ddram_address(0x46);
  st7066_write_data('%');
}

void sensor_proc(void)
{
  counter++;
  if (counter == SENSOR_UPDATE_PERIOD)
  {
    counter = 0;
  }
}
