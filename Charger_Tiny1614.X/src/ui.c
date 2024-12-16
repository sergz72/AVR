#include "board.h"
#include "ui.h"

#include <string.h>
#include <fonts/font5.h>
#include "controller.h"

#define MODE_NONE 0
#define MODE_SELECT_ITEM 1
#define MODE_EDIT_ITEM 2
#define MODE_EDIT_VALUE 3
#define MAX_MODE 3

#define HEADER_FONT fiveBySevenFontInfo
#define CURRENT_VOLTAGE_FONT fiveBySevenFontInfo
#define FACT_CURRENT_VOLTAGE_Y (64-CURRENT_VOLTAGE_FONT.char_height)
#define SET_CURRENT_VOLTAGE_Y (64-2*CURRENT_VOLTAGE_FONT.char_height)

#define GET_X(font, pos) ((font.character_max_width + font.character_spacing) * pos)

static unsigned char value_buffer[6];
static int mode;
static int selected_program_item_no;
static int selected_program_step_digit;
static ProgramItem *selected_program_item;
static ProgramItem current_editor_item;

static void DrawValue4(unsigned int x, unsigned int y, const FONT_INFO *font, int value, int show_sign,
                       unsigned int textColor, unsigned int bkColor)
{
  unsigned char *p = value_buffer;
  if (show_sign)
    *p++ = value < 0 ? '-' : ' ';
  if (value < 0)
    value = -value;
  p[4] = 0;
  for (int i = 3; i >= 0; i--)
  {
    if (i < 3 && value == 0)
      p[i] = ' ';
    else
    {
      p[i] = (value % 10) + '0';
      value /= 10;
    }
  }
  LcdDrawText(x, y, (char*)value_buffer, font, textColor, bkColor, NULL);
}

static void DrawValue1(unsigned int x, unsigned int y, const FONT_INFO *font, unsigned int value,
                       unsigned int textColor, unsigned int bkColor)
{
  value_buffer[0] = (value % 10) + '0';
  value_buffer[1] = 0;
  LcdDrawText(x, y, (char*)value_buffer, font, textColor, bkColor, NULL);
}

static void DrawValue3(unsigned int x, unsigned int y, const FONT_INFO *font, unsigned int value,
                       unsigned int textColor, unsigned int bkColor, int selectedItem)
{
  int idx = 0;
  for (int i = 100; i >= 1; i /= 10)
  {
    DrawValue1(x, y, font, value / i, selectedItem == idx ? bkColor : textColor,
               selectedItem == idx ? textColor : bkColor);
    x += font->character_max_width + font->character_spacing;
    idx++;
  }
}

static void ShowSetVoltage(unsigned int voltage)
{
  DrawValue4(0, SET_CURRENT_VOLTAGE_Y, &CURRENT_VOLTAGE_FONT, (int)voltage, 0,
            BLACK_COLOR, WHITE_COLOR);
}

static void ShowSetCurrent(unsigned int current)
{
  DrawValue4(GET_X(CURRENT_VOLTAGE_FONT, 10), SET_CURRENT_VOLTAGE_Y, &CURRENT_VOLTAGE_FONT, (int)current,
            1, BLACK_COLOR, WHITE_COLOR);
}

static void ShowFactVoltage(unsigned int voltage)
{
  DrawValue4(0, FACT_CURRENT_VOLTAGE_Y, &CURRENT_VOLTAGE_FONT, (int)voltage, 0,
            WHITE_COLOR, BLACK_COLOR);
}

static void ShowFactCurrent(int current)
{
  DrawValue4(GET_X(CURRENT_VOLTAGE_FONT, 10), FACT_CURRENT_VOLTAGE_Y, &CURRENT_VOLTAGE_FONT, current,
            1, WHITE_COLOR, BLACK_COLOR);
}

static void DrawProgramNumber(unsigned int id, unsigned int textColor, unsigned int bkColor)
{
  value_buffer[0] = id + '1';
  value_buffer[1] = 0;
  LcdDrawText(0, HEADER_FONT.char_height * (id + 1), (char*)value_buffer, &HEADER_FONT, textColor,
              bkColor, NULL);
}

static void DrawProgramStep(ProgramItem *step, int stepNo, int reverseColors)
{
  unsigned int textColor = reverseColors ? BLACK_COLOR : WHITE_COLOR;
  unsigned int bkColor = reverseColors ? WHITE_COLOR : BLACK_COLOR;
  if (is_program_step_valid(step))
  {
    value_buffer[0] = step->mode == MODE_CHARGE ? 'C' : step->mode == MODE_DISCHARGE ? 'D' : 'X';
    value_buffer[1] = 0;
    unsigned int y = HEADER_FONT.char_height * stepNo;
    LcdDrawText(GET_X(HEADER_FONT, 1), y, (char*)value_buffer, &HEADER_FONT,
        selected_program_step_digit == 0 ? bkColor : textColor,
                selected_program_step_digit == 0 ? textColor : bkColor, NULL);
    DrawValue3(GET_X(HEADER_FONT, 3), y, &HEADER_FONT, step->trigger_voltage / 10, textColor, bkColor,
               selected_program_step_digit < 4 ? selected_program_step_digit - 1 : -1);
    DrawValue3(GET_X(HEADER_FONT, 7), y, &HEADER_FONT, step->max_current / 10, textColor, bkColor,
               selected_program_step_digit < 7 ? selected_program_step_digit - 4 : -1);
    DrawValue3(GET_X(HEADER_FONT, 11), y, &HEADER_FONT, step->stop_current / 10, textColor, bkColor,
               selected_program_step_digit < 10 ? selected_program_step_digit - 7 : -1);
    DrawValue3(GET_X(HEADER_FONT, 15), y, &HEADER_FONT, step->voltage / 10, textColor, bkColor,
      selected_program_step_digit - 10);
  }
  else
    LcdDrawText(GET_X(HEADER_FONT, 1), HEADER_FONT.char_height * stepNo, " |   |   |   |    ", &HEADER_FONT,
                textColor, bkColor, NULL);
}

static void DrawProgramSteps(ProgramItem *step, int selected)
{
  for (int stepNo = 1; stepNo <= MAX_PROGRAM_ITEMS; stepNo++)
  {
    DrawProgramStep(step, stepNo, selected == stepNo);
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
  DrawProgramSteps(get_program_steps(), -1);
}

static void SwitchMode(int up)
{
  switch (mode)
  {
    case MODE_NONE:
      DrawProgramSteps(get_program_steps(), -1);
    break;
    case MODE_SELECT_ITEM:
      selected_program_item_no = 1;
      selected_program_step_digit = -1;
      selected_program_item = get_program_steps();
      DrawProgramSteps(selected_program_item, selected_program_item_no);
      break;
    case MODE_EDIT_ITEM:
      if (up)
      {
        if (!is_program_step_valid(selected_program_item))
          create_program_item(&current_editor_item);
        else
          memcpy(&current_editor_item, selected_program_item, sizeof(ProgramItem));
        selected_program_step_digit = 0;
      }
      DrawProgramStep(&current_editor_item, selected_program_item_no, 1);
      break;
    case MODE_EDIT_VALUE:
      DrawProgramStep(&current_editor_item, selected_program_item_no, 0);
      break;
  }
}

static unsigned int GetNext(unsigned int value, int counter, unsigned int max)
{
  if (counter > 0)
  {
    value += (unsigned int)counter;
    if (value > max)
      return max;
    return value;
  }
  counter = -counter;
  if (value > counter)
    return value - (unsigned int)counter;
  return 0;
}

static unsigned int GetNewValue(unsigned int v, int counter, int diff, unsigned int max)
{
  counter *= diff;
  if (counter > 0)
  {
    v += (unsigned int)counter;
    if (v > max)
      return max;
    return v;
  }
  counter = -counter;
  if (v > counter)
    return v - (unsigned int)counter;
  return 0;
}

static void UpdateValue(int counter)
{
  switch (selected_program_step_digit)
  {
    case 0: // mode
      current_editor_item.mode =
        current_editor_item.mode == MODE_CHARGE ? MODE_DISCHARGE :
          (current_editor_item.mode == MODE_DISCHARGE ? MODE_DELETE : MODE_CHARGE);
      break;
    case 1: // thousands of trigger voltage
      current_editor_item.trigger_voltage = GetNewValue(current_editor_item.trigger_voltage, counter, 1000, MAX_VOLTAGE);
      break;
    case 2: // hundreds of trigger voltage
      current_editor_item.trigger_voltage = GetNewValue(current_editor_item.trigger_voltage, counter, 100, MAX_VOLTAGE);
      break;
    case 3: // tens of trigger voltage
      current_editor_item.trigger_voltage = GetNewValue(current_editor_item.trigger_voltage, counter, 10, MAX_VOLTAGE);
      break;
    case 4: // thousands of max current
      current_editor_item.max_current = GetNewValue(current_editor_item.max_current, counter, 1000, MAX_CURRENT);
      break;
    case 5: // hundreds of max current
      current_editor_item.max_current = GetNewValue(current_editor_item.max_current, counter, 100, MAX_CURRENT);
      break;
    case 6: // tens of max current
      current_editor_item.max_current = GetNewValue(current_editor_item.max_current, counter, 10, MAX_CURRENT);
      break;
    case 7: // thousands of stop current
      current_editor_item.stop_current = GetNewValue(current_editor_item.stop_current, counter, 1000, MAX_CURRENT);
      break;
    case 8: // hundreds of stop current
      current_editor_item.stop_current = GetNewValue(current_editor_item.stop_current, counter, 100, MAX_CURRENT);
      break;
    case 9: // tens of stop current
      current_editor_item.stop_current = GetNewValue(current_editor_item.stop_current, counter, 100, MAX_CURRENT);
      break;
    case 10: // thousands of voltage
      current_editor_item.voltage = GetNewValue(current_editor_item.voltage, counter, 1000, MAX_VOLTAGE);
      break;
    case 11: // hundreds of voltage
      current_editor_item.voltage = GetNewValue(current_editor_item.voltage, counter, 100, MAX_VOLTAGE);
      break;
    case 12: // tens of voltage
      current_editor_item.voltage = GetNewValue(current_editor_item.voltage, counter, 10, MAX_VOLTAGE);
      break;
  }
  DrawProgramStep(&current_editor_item, selected_program_item_no, 0);
}

static void ChangeSelection(int counter)
{
  switch (mode)
  {
    case MODE_NONE:
      SelectProgram(GetNext(get_current_program(), -counter, MAX_PROGRAMS - 1));
      break;
    case MODE_SELECT_ITEM:
      if ((counter < 0 && selected_program_item_no > 1) || is_program_step_valid(selected_program_item))
      {
        selected_program_item_no = GetNext(selected_program_item_no, counter, MAX_PROGRAM_ITEMS - 1);
        if (selected_program_item_no == 0)
          selected_program_item_no = 1;
        selected_program_item = &get_program_steps()[selected_program_item_no - 1];
        DrawProgramSteps(get_program_steps(), selected_program_item_no);
      }
      break;
    case MODE_EDIT_ITEM:
      selected_program_step_digit = GetNext(selected_program_step_digit, counter, 12);
      DrawProgramStep(&current_editor_item, selected_program_item_no, 1);
      break;
    case MODE_EDIT_VALUE:
      UpdateValue(counter);
      break;
  }
}

static void SaveChanges(void)
{
  if (selected_program_item != NULL)
  {
    if (current_editor_item.mode == MODE_DELETE)
      current_editor_item.mode = 0xFF;
    memcpy(selected_program_item, &current_editor_item, sizeof(current_editor_item));
    save_program_data();
  }
}

void UI_Init(void)
{
  mode = MODE_NONE;
  selected_program_item = NULL;
  selected_program_step_digit = -1;

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
  DrawProgramSteps(NULL, -1);
  SelectProgram(0);
  LcdDrawText(GET_X(CURRENT_VOLTAGE_FONT, 4), SET_CURRENT_VOLTAGE_Y, " mV   ", &CURRENT_VOLTAGE_FONT,
              BLACK_COLOR, WHITE_COLOR, NULL);
  LcdDrawText(GET_X(CURRENT_VOLTAGE_FONT, 15), SET_CURRENT_VOLTAGE_Y, " mA ", &CURRENT_VOLTAGE_FONT,
              BLACK_COLOR, WHITE_COLOR, NULL);
  LcdDrawText(GET_X(CURRENT_VOLTAGE_FONT, 4), FACT_CURRENT_VOLTAGE_Y, " mV", &CURRENT_VOLTAGE_FONT,
              WHITE_COLOR, BLACK_COLOR, NULL);
  LcdDrawText(GET_X(CURRENT_VOLTAGE_FONT, 15), FACT_CURRENT_VOLTAGE_Y, " mA ", &CURRENT_VOLTAGE_FONT,
              WHITE_COLOR, BLACK_COLOR, NULL);
  LcdUpdate();
}

void Process_Timer_Event(signed char keyboard_status, unsigned int voltage, int current)
{
  ProgramItem *current_step = get_current_step();
  ShowSetVoltage(current_step == NULL ? 0 : current_step->voltage);
  ShowSetCurrent(current_step == NULL ? 0 : current_step->max_current);
  ShowFactVoltage(voltage);
  ShowFactCurrent(current);
  if (is_program_running())
  {
    if ((keyboard_status & 0x0F) == KB_EXIT)
      stop_program();
    LcdUpdate();
    return;
  }
  switch (keyboard_status & 0x0F)
  {
    case KB_SELECT:
      if (mode < MAX_MODE)
      {
        mode++;
        SwitchMode(1);
      }
      break;
    case KB_EXIT:
      if (mode)
      {
        mode--;
        SwitchMode(0);
      }
      break;
    case KB_ENCODER:
      ChangeSelection(keyboard_status >> 4);
      break;
    case KB_EXIT_LONG:
      if (mode == MODE_NONE)
        start_program(voltage);
      else if (mode == MODE_EDIT_ITEM)
      {
        SaveChanges();
        mode--;
        SwitchMode(0);
      }
      break;
    default:
      break;
  }
  LcdUpdate();
}
