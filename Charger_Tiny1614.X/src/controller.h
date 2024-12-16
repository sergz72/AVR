#ifndef _CONTROLLER_H
#define _CONTROLLER_H

#define MODE_CHARGE 0x55
#define MODE_DISCHARGE 0xAA
#define MODE_DELETE 0x11

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
ProgramItem *get_current_step(void);
int is_program_step_valid(ProgramItem *step);
void create_program_item(ProgramItem *step);
void start_program(unsigned int voltage);
void stop_program();
int is_program_running();
void save_program_data(void);

#endif
