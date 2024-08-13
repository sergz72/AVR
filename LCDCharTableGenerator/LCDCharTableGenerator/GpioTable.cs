namespace LCDCharTableGenerator;

internal sealed class GpioTable
{
    internal struct Gpio
    {
        internal int ByteNo;
        internal int BitNo;

        internal Gpio(string line)
        {
            var parts = line.Split(',');
            if (parts.Length != 2 || !int.TryParse(parts[0], out ByteNo) || !int.TryParse(parts[1], out BitNo))
                throw new Exception($"wrong gpio line: {line}");
        }
    }

    internal readonly List<Gpio> Gpios;
    internal readonly int ByteCount;
    
    internal GpioTable(string fileName)
    {
        var lines = File.ReadAllLines(fileName);
        Gpios = []; 
        foreach (var line in lines)
            Gpios.Add(new Gpio(line));
        ByteCount = Gpios.Max(g => g.ByteNo) + 1;
    }
}