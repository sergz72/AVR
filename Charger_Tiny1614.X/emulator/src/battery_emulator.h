#ifndef BATTERY_EMULATOR_H
#define BATTERY_EMULATOR_H

void set_battery_voltage(unsigned int mv);
void set_battery_capacity(unsigned int mah);
unsigned int get_next_voltage(unsigned int ms, int current);

#endif
