cmake_minimum_required(VERSION 3.29)
SET(CMAKE_SYSTEM_NAME Generic)

SET(CMAKE_C_COMPILER_WORKS 1)

set(CMAKE_C_STANDARD 11)

SET(CMAKE_C_FLAGS "-mmcu=atxmega32e5")
SET(CMAKE_EXE_LINKER_FLAGS "-Wl,-gc-sections,--print-memory-usage")

project(Voltmeter_X C)

add_executable(Voltmeter_X main.c lcd_char_table.c hal.c ../common_lib/segment_lcd.c)

include_directories(. ../common_lib)
