cmake_minimum_required(VERSION 3.30)
project(ChargerUI C)

set(CMAKE_C_STANDARD 23)

add_executable(ChargerUI
        src/hal.c
        src/ui.c
        src/main.c
        src/controller.c
        src/battery_emulator.c
        ../../ARM/common_lib/display/lcd_ssd1306.c
        ../../ARM/common_lib/display/lcd.c
        ../../ARM/common_lib/display/font.c
        ../../ARM/common_lib/display/fonts/font5.c
)

include_directories(
        c:/utils/msys64/ucrt64/include/gtk-4.0
        c:/utils/msys64/ucrt64/include/glib-2.0
        c:/utils/msys64/ucrt64/lib/glib-2.0/include
        c:/utils/msys64/ucrt64/include/cairo
        c:/utils/msys64/ucrt64/include/pango-1.0
        c:/utils/msys64/ucrt64/include/harfbuzz
        c:/utils/msys64/ucrt64/include/gdk-pixbuf-2.0
        c:/utils/msys64/ucrt64/include/graphene-1.0
        c:/utils/msys64/ucrt64/lib/graphene-1.0/include
        src
        ../../ARM/common_lib
        ../../ARM/common_lib/display
)

target_link_libraries(ChargerUI
        c:/utils/msys64/ucrt64/lib/libgtk-4.dll.a
        c:/utils/msys64/ucrt64/lib/libglib-2.0.dll.a
        c:/utils/msys64/ucrt64/lib/libpango-1.0.dll.a
        c:/utils/msys64/ucrt64/lib/libgobject-2.0.dll.a
        c:/utils/msys64/ucrt64/lib/libcairo.dll.a
        c:/utils/msys64/ucrt64/lib/libgdk_pixbuf-2.0.dll.a
        c:/utils/msys64/ucrt64/lib/libharfbuzz.dll.a
        c:/utils/msys64/ucrt64/lib/libgraphene-1.0.dll.a
        c:/utils/msys64/ucrt64/lib/libgio-2.0.dll.a
)
