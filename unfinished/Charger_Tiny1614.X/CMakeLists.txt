cmake_minimum_required(VERSION 3.29)
SET(CMAKE_SYSTEM_NAME Generic)

SET(CMAKE_C_COMPILER_WORKS 1)

set(CMAKE_C_STANDARD 11)

SET(CMAKE_C_FLAGS "-mmcu=attiny1614")
SET(CMAKE_EXE_LINKER_FLAGS "-Wl,-gc-sections,--print-memory-usage")

project(Charger C)

add_executable(Charger
  src/main.c
  src/hal.c
  src/controller.c
  src/ui.c
  ../../ARM/common_lib/display/lcd_ssd1306.c
  ../../ARM/common_lib/display/lcd.c
  ../../ARM/common_lib/display/font.c
  ../../ARM/common_lib/display/fonts/font5.c
)

include_directories(SRC ../common_lib ../../ARM/common_lib/display)
