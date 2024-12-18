#include "board.h"
#include "controller.h"

static ProgramItem programs[MAX_PROGRAMS][MAX_PROGRAM_ITEMS];
static ProgramItem *current_program_step;
static int current_program, current_current, pause;

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

ProgramItem *get_current_step(void)
{
  return current_program_step;
}

int is_program_step_valid(ProgramItem *step)
{
  return step != NULL && (step->mode == MODE_CHARGE || step->mode == MODE_DISCHARGE || step->mode == MODE_DELETE);
}

void create_program_item(ProgramItem *step)
{
  step->mode = MODE_DISCHARGE;
  step->voltage = 4200;
  step->max_current = MAX_CURRENT;
  step->stop_current = 50;
  step->trigger_voltage = 4000;
}

void controller_init(void)
{
  current_program_step = NULL;
  current_program = 0;
  current_current = 0;
  pause = 0;
  load_data(programs, sizeof programs);
}

void save_program_data(void)
{
  save_data(programs, sizeof programs);
}

static int select_program(unsigned int voltage)
{
  while (current_program_step - programs[current_program] < MAX_PROGRAM_ITEMS - 1 &&
         is_program_step_valid(current_program_step))
  {
    if (current_program_step->mode == MODE_CHARGE)
    {
      if (voltage <= current_program_step->trigger_voltage)
        return 1;
    }
    else
    {
      if (voltage >= current_program_step->trigger_voltage)
        return 1;
    }
    current_program_step++;
  }
  stop_program();
  return 0;
}

static void next_program_step(unsigned int voltage)
{
  current_current = 0;
  if (current_program_step - programs[current_program] == MAX_PROGRAM_ITEMS - 1)
  {
    stop_program();
    return;
  }
  current_program_step++;
  if (!select_program(voltage))
    return;
  if (!is_program_step_valid(current_program_step))
    stop_program();
  else
    pause = 10 * 1000 / TIMER_DELAY;
}

static void update_charge_current(unsigned int voltage)
{
  if (voltage > current_program_step->voltage)
  {
    current_current -= 10;
    if (current_current < (int)current_program_step->stop_current)
      next_program_step(voltage);
  }
  else if (voltage < current_program_step->voltage)
  {
    current_current += 10;
    if (current_current > (int)current_program_step->max_current)
      current_current = current_program_step->max_current;
  }
}

static void update_discharge_current(unsigned int voltage)
{
  if (voltage > current_program_step->voltage)
  {
    if (current_current <= (int)current_program_step->max_current - 10)
      current_current += 10;
  }
  else if (voltage < current_program_step->voltage)
      next_program_step(voltage);
}

int update_current(unsigned int voltage)
{
  if (current_program_step == NULL)
    return 0;
  if (pause)
  {
    pause--;
    return 0;
  }
  if (current_program_step->mode == MODE_CHARGE)
  {
    update_charge_current(voltage);
    return current_current;
  }
  update_discharge_current(voltage);
  return -current_current;
}

void start_program(unsigned int voltage)
{
  current_program_step = programs[current_program];
  select_program(voltage);
}

void stop_program(void)
{
  current_program_step = NULL;
  current_current = 0;
}

int is_program_running(void)
{
  return current_program_step != NULL;
}
