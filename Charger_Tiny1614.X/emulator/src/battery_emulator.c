#include "battery_emulator.h"

#define MAX_VOLTAGE 4350.0
#define MIN_VOLTAGE 2500.0
#define MILLISECONDS_IN_HOUR (3600.0 * 1000.0)
#define R 0.2

static double voltage = 3700;
static double capacity = 4000;
static double current_capacity = 3000;

void set_battery_voltage(unsigned int mv)
{
  voltage = mv;
  current_capacity = ((double)mv - MIN_VOLTAGE) * capacity / (MAX_VOLTAGE - MIN_VOLTAGE);
}

void set_battery_capacity(unsigned int mah)
{
  capacity = mah;
  set_battery_voltage(voltage);
}

unsigned int get_next_voltage(unsigned int ms, int current)
{
  double mah = (double)ms * current / MILLISECONDS_IN_HOUR;
  current_capacity += mah;
  voltage = MIN_VOLTAGE + (MAX_VOLTAGE -  MIN_VOLTAGE) * current_capacity / capacity;
  return (unsigned int)voltage + current * R;
}
