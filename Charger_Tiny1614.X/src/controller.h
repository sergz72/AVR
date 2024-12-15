#ifndef _CONTROLLER_H
#define _CONTROLLER_H

#define MODE_CHARGE 0x55
#define MODE_DISCHARGE 0xAA

typedef struct {
  int mode;
  unsigned int trigger_voltage;
  unsigned int max_current;
  unsigned int stop_current;
  unsigned int voltage;
} ProgramItem;

int update_current(unsigned int voltage);
void controller_init(void);
void set_current_program(int id);
unsigned int get_current_program(void);
ProgramItem *get_program_steps(void);
int is_program_step_valid(ProgramItem *step);
void start_program();
void stop_program();

#endif
