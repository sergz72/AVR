@ECHO OFF
"d:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\serg\my\Programs\AVR\oven_control\labels.tmp" -fI -W+ie -C V2E -o "D:\serg\my\Programs\AVR\oven_control\oven_control.hex" -d "D:\serg\my\Programs\AVR\oven_control\oven_control.obj" -e "D:\serg\my\Programs\AVR\oven_control\oven_control.eep" -m "D:\serg\my\Programs\AVR\oven_control\oven_control.map" "D:\serg\my\Programs\AVR\oven_control\oven_control.asm"
