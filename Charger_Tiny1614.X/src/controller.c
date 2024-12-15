#include "board.h"
#include "controller.h"

static ProgramItem programs[MAX_PROGRAMS][MAX_PROGRAM_ITEMS];
static ProgramItem *current_program_step;
static int current_program;

void set_current_program(int id)
{
  current_program = id;
}

unsigned int get_current_program(void)
{
  return current_program;
}

ProgramItem *get_program_steps(void)
{
  return programs[current_program];
}

int is_program_step_valid(ProgramItem *step)
{
  return step != NULL && (step->mode == MODE_CHARGE || step->mode == MODE_DISCHARGE);
}

void controller_init(void)
{
  current_program_step = NULL;
  current_program = 0;
  load_data(programs, sizeof programs);
}

int update_current(unsigned int voltage)
{
  if (current_program_step == NULL)
    return 0;
  return 1000;
}

void start_program()
{

}

void stop_program()
{
  
}
