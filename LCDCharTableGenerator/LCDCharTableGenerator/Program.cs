using LCDCharTableGenerator;

if (args.Length != 1)
{
    Console.WriteLine("Usage: LCDCharTableGenerator lcd_definitions_folder_path");
    return;
}

var charTable = new CharTable(Path.Combine(args[0], "char_table.txt"));
var pinTable = new PinTable(Path.Combine(args[0], "pin_table.txt"));
var gpioTable = new GpioTable(Path.Combine(args[0], "gpio_table.txt"));

var generator = new LCDCharTableGenerator.LCDCharTableGenerator(charTable, pinTable, gpioTable);
var table = generator.GenerateCharTable();

foreach (var line in table)
    Console.WriteLine(line);
