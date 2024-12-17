#include "board.h"
#include "controller.h"
#include "ui.h"
#include "battery_emulator.h"
#include <gtk/gtk.h>

signed char keyboard_state = 0;
int exit_delay = 0;
int exit_long_press = 0;

static void
draw_cb (GtkDrawingArea *drawing_area,
         cairo_t        *cr,
         int             width,
         int             height,
         gpointer        data)
{
  cairo_set_source_rgb (cr, 0, 0, 0);
  cairo_paint (cr);
  cairo_set_source_rgb (cr, 1, 1, 1);
  for (int y = 0; y < LCD_HWHEIGHT; y++)
  {
    for (int x = 0; x < LCD_HWWIDTH; x++)
    {
      if (get_lcd_buffer_bit(x, y))
        cairo_rectangle (cr, x * ZOOM + ZOOM/2 , y * ZOOM + ZOOM/2, ZOOM, ZOOM);
    }
  }
  cairo_fill(cr);
}

static void
close_window (void)
{
}

static gboolean time_handler(GtkWidget *widget)
{

  if (widget == NULL) return FALSE;

  signed char keyboard_status = get_keyboard_status();
  unsigned int v = get_voltage();
  int current = update_current(v);
  set_current(current);
  Process_Timer_Event(keyboard_status, v, current);

  gtk_widget_queue_draw(widget);

  return TRUE;
}

static void
upEvent (GtkWidget *widget,
             gpointer   data)
{
  keyboard_state = KB_ENCODER | 0x10;
}

static void
downEvent (GtkWidget *widget,
    gpointer   data)
{
  keyboard_state = KB_ENCODER | 0xF0;
}

static void
exitEvent (GtkWidget *widget,
           gpointer   data)
{
  exit_delay = 2;
}

static void
exitLongEvent (GtkWidget *widget,
           gpointer   data)
{
  exit_long_press = 1;
}

static void
selectEvent (GtkWidget *widget,
             gpointer   data)
{
  keyboard_state = KB_SELECT;
}

static void
activate (GtkApplication *app,
          gpointer        user_data)
{
  GtkWidget *window;
  GtkWidget *hbox, *vbox;
  GtkWidget *button;
  GtkWidget *drawing_area;

  window = gtk_application_window_new (app);
  gtk_window_set_title (GTK_WINDOW (window), "Charger/discharger");
  gtk_window_set_resizable(GTK_WINDOW (window), FALSE);
  gtk_widget_set_size_request (window, ZOOM * LCD_HWWIDTH + 100, ZOOM * LCD_HWHEIGHT);

  g_signal_connect (window, "destroy", G_CALLBACK (close_window), NULL);

  hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 0);
  gtk_window_set_child (GTK_WINDOW (window), hbox);

  drawing_area = gtk_drawing_area_new ();
  gtk_widget_set_size_request (drawing_area, ZOOM * LCD_HWWIDTH, ZOOM * LCD_HWHEIGHT);

  gtk_box_append (GTK_BOX (hbox), drawing_area);

  gtk_drawing_area_set_draw_func (GTK_DRAWING_AREA (drawing_area), draw_cb, NULL, NULL);

  vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
  gtk_box_append (GTK_BOX (hbox), vbox);
  gtk_widget_set_halign (vbox, GTK_ALIGN_END);
  gtk_widget_set_valign (vbox, GTK_ALIGN_END);

  button = gtk_button_new_with_label ("UP");
  g_signal_connect (button, "clicked", G_CALLBACK (upEvent), NULL);
  gtk_box_append (GTK_BOX (vbox), button);
  button = gtk_button_new_with_label ("DOWN");
  g_signal_connect (button, "clicked", G_CALLBACK (downEvent), NULL);
  gtk_box_append (GTK_BOX (vbox), button);
  button = gtk_button_new_with_label ("SELECT");
  g_signal_connect (button, "clicked", G_CALLBACK (selectEvent), NULL);
  gtk_box_append (GTK_BOX (vbox), button);

  GtkGesture *gesture = gtk_gesture_long_press_new ();

  button = gtk_button_new_with_label ("EXIT");
  g_signal_connect (button, "clicked", G_CALLBACK (exitEvent), NULL);
  g_signal_connect (gesture, "pressed", G_CALLBACK (exitLongEvent), NULL);
  if (gtk_button_get_child (GTK_BUTTON (button)))
    gtk_widget_add_controller (gtk_button_get_child (GTK_BUTTON (button)), GTK_EVENT_CONTROLLER (gesture));
  else
    gtk_widget_add_controller (button, GTK_EVENT_CONTROLLER (gesture));
  gtk_box_append (GTK_BOX (vbox), button);

  gtk_window_present (GTK_WINDOW (window));

  controller_init();
  UI_Init();

  g_timeout_add(TIMER_DELAY, (GSourceFunc)time_handler, drawing_area);
}

int
main (int    argc,
      char **argv)
{
  GtkApplication *app;
  int status;

  set_battery_capacity(400);
  unsigned int battery_voltage = 3700;
  if (argc > 1)
  {
    battery_voltage = atoi(argv[1]);
    if (battery_voltage < 2500)
      battery_voltage = 2500;
    else if (battery_voltage > 4200)
      battery_voltage = 4200;
  }

  set_battery_voltage(battery_voltage);

  app = gtk_application_new ("charger.ui", G_APPLICATION_DEFAULT_FLAGS);
  g_signal_connect (app, "activate", G_CALLBACK (activate), NULL);
  status = g_application_run (G_APPLICATION (app), argc, argv);
  g_object_unref (app);

  return status;
}
