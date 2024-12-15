#include "board.h"
#include "ui.h"
#include <fonts/font8_2.h>
#include <fonts/font5.h>
#include "controller.h"

#define MODE_NONE 0
#define MODE_SELECT_ITEM 1
#define MODE_EDIT_ITEM 2
#define MODE_EDIT_VALUE 3
#define MAX_MODE 3

#define HEADER_FONT fiveBySevenFontInfo
#define CURRENT_VOLTAGE_FONT courierNew8ptFontInfo
#define CURRENT_VOLTAGE_Y (64-CURRENT_VOLTAGE_FONT.char_height)

#define GET_X(font, pos) (font.character_max_width + font.character_spacing) * pos

static unsigned char value_buffer[6];
static int mode;
static ProgramItem *current_step;
static ProgramItem current_editor_item;

static void DrawValue(unsigned int x, unsigned int y, const FONT_INFO *font, int value, int show_sign,
                      unsigned int textColor, unsigned int bkColor)
{
  unsigned char *p = value_buffer;
  if (show_sign)
    *p++ = value < 0 ? '-' : ' ';
  if (value < 0)
    value = -value;
  *p++ = value >= 1000 ? value / 1000 + '0' :  ' ';
  *p++ = value > 100 ? ((value / 100) % 10) + '0' : ' ';
  *p++ = value > 10 ? ((value / 10) % 10) + '0' : ' ';
  *p++ = value % 10 + '0';
  *p = 0;
  LcdDrawText(x, y, (char*)value_buffer, font, textColor, bkColor, NULL);
}

static void DrawValue3(unsigned int x, unsigned int y, const FONT_INFO *font, unsigned int value,
                      unsigned int textColor, unsigned int bkColor)
{
  unsigned char *p = value_buffer;
  *p++ = value > 100 ? value / 100 + '0' : ' ';
  *p++ = value > 10 ? ((value / 10) % 10) + '0' : ' ';
  *p++ = value % 10 + '0';
  *p = 0;
  LcdDrawText(x, y, (char*)value_buffer, font, textColor, bkColor, NULL);
}

static void ShowVoltage(unsigned int voltage)
{
  DrawValue(0, CURRENT_VOLTAGE_Y, &CURRENT_VOLTAGE_FONT, (int)voltage, 0,
            WHITE_COLOR, BLACK_COLOR);
}

static void ShowCurrent(int current)
{
  DrawValue(GET_X(CURRENT_VOLTAGE_FONT, 7), CURRENT_VOLTAGE_Y, &CURRENT_VOLTAGE_FONT, current,
            1, WHITE_COLOR, BLACK_COLOR);
}

static void DrawProgramNumber(unsigned int id, unsigned int textColor, unsigned int bkColor)
{
  value_buffer[0] = id + '1';
  value_buffer[1] = 0;
  LcdDrawText(0, HEADER_FONT.char_height * (id + 1), (char*)value_buffer, &HEADER_FONT, textColor,
              bkColor, NULL);
}

static void DrawProgramStep(ProgramItem *step, int stepNo)
{
  unsigned int textColor = WHITE_COLOR;
  unsigned int bkColor = BLACK_COLOR;
  if (is_program_step_valid(step))
  {
    value_buffer[0] = step->mode == MODE_CHARGE ? 'C' : 'D';
    value_buffer[1] = 0;
    unsigned int y = HEADER_FONT.char_height * stepNo;
    LcdDrawText(GET_X(HEADER_FONT, 1), y, (char*)value_buffer, &HEADER_FONT,textColor,
                bkColor, NULL);
    DrawValue3(GET_X(HEADER_FONT, 3), y, &HEADER_FONT, step->trigger_voltage / 10, textColor, bkColor);
    DrawValue3(GET_X(HEADER_FONT, 7), y, &HEADER_FONT, step->max_current / 10, textColor, bkColor);
    DrawValue3(GET_X(HEADER_FONT, 11), y, &HEADER_FONT, step->stop_current / 10, textColor, bkColor);
    DrawValue3(GET_X(HEADER_FONT, 15), y, &HEADER_FONT, step->voltage / 10, textColor, bkColor);
  }
  else
    LcdDrawText(GET_X(HEADER_FONT, 1), HEADER_FONT.char_height * stepNo, " |   |   |   |   ", &HEADER_FONT,
                textColor, bkColor, NULL);
}

static void DrawProgramSteps(ProgramItem *step)
{
  for (int stepNo = 1; stepNo <= MAX_PROGRAM_ITEMS; stepNo++)
  {
    DrawProgramStep(step, stepNo);
    if (step != NULL)
      step++;
  }
}

static void SelectProgram(unsigned int id)
{
  unsigned int old_id = get_current_program();
  set_current_program(id);
  DrawProgramNumber(old_id, WHITE_COLOR, BLACK_COLOR);
  DrawProgramNumber(id, BLACK_COLOR, WHITE_COLOR);
  DrawProgramSteps(get_program_steps());
}

static void SwitchMode(void)
{

}

static unsigned int GetNext(unsigned int value, int up, unsigned int max)
{
  if (up)
  {
    if (value == max)
      return 0;
    return value + 1;
  }
  if (value == 0)
    return max;
  return value - 1;
}

static void ChangeSelection(int up)
{
  switch (mode)
  {
    case MODE_NONE:
      SelectProgram(GetNext(get_current_program(), up ? 0 : 1, MAX_PROGRAMS - 1));
      break;
  }
}

static void SaveChanges(void)
{

}

void UI_Init(void)
{
  mode = MODE_NONE;
  current_step = NULL;

  LcdInit();
  LcdDrawText(0, 0, "PM|Trg|MxC|StC|Vol ", &HEADER_FONT, BLACK_COLOR, WHITE_COLOR, NULL);
  value_buffer[1] = 0;
  unsigned int y = HEADER_FONT.char_height + 1;
  for (unsigned char i = 1; i <= MAX_PROGRAMS; i++)
  {
    value_buffer[0] = i + '0';
    LcdDrawText(0, y, (char*)value_buffer, &HEADER_FONT, WHITE_COLOR,
                BLACK_COLOR, NULL);
    y += HEADER_FONT.char_height;
  }
  DrawProgramSteps(NULL);
  SelectProgram(0);
  LcdDrawText(GET_X(CURRENT_VOLTAGE_FONT, 4), CURRENT_VOLTAGE_Y, "mV", &CURRENT_VOLTAGE_FONT,
              WHITE_COLOR, BLACK_COLOR, NULL);
  LcdDrawText(GET_X(CURRENT_VOLTAGE_FONT, 12), CURRENT_VOLTAGE_Y, "mA", &CURRENT_VOLTAGE_FONT,
              WHITE_COLOR, BLACK_COLOR, NULL);
  LcdUpdate();
}

void Process_Timer_Event(unsigned int keyboard_status, unsigned int voltage, int current)
{
  ShowVoltage(voltage);
  ShowCurrent(current);
  switch (keyboard_status)
  {
    case KB_SELECT:
      if (mode < MAX_MODE)
      {
        mode++;
        SwitchMode();
      }
      break;
    case KB_EXIT:
      if (mode)
      {
        mode--;
        SwitchMode();
      }
      else
        stop_program();
      break;
    case KB_UP:
      ChangeSelection(1);
      break;
    case KB_DOWN:
      ChangeSelection(0);
      break;
    case KB_ENTER:
      if (mode == MODE_NONE)
        start_program();
      if (mode > MODE_SELECT_ITEM)
        SaveChanges();
      break;
    default:
      break;
  }
  LcdUpdate();
}
