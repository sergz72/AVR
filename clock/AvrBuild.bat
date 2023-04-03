@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\serg\my\Programs\AVR\clock\labels.tmp" -fI -W+ie -C V2E -o "D:\serg\my\Programs\AVR\clock\clock.hex" -d "D:\serg\my\Programs\AVR\clock\clock.obj" -e "D:\serg\my\Programs\AVR\clock\clock.eep" -m "D:\serg\my\Programs\AVR\clock\clock.map" "D:\serg\my\Programs\AVR\clock\clock.asm"
