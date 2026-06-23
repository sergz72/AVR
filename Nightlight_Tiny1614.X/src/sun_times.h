#ifndef SUN_TIMES_H
#define	SUN_TIMES_H

typedef struct
{
  unsigned char rise_hours;
  unsigned char rise_minutes;
  unsigned char down_hours;
  unsigned char down_minutes;
} sun_time;

extern const sun_time sun_times[366];

#endif


