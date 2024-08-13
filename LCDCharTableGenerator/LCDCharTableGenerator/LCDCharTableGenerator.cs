using System.Text;

namespace LCDCharTableGenerator;

internal sealed class LCDCharTableGenerator
{
    private CharTable _charTable;
    private PinTable _pinTable;
    private GpioTable _gpioTable;
    
    internal LCDCharTableGenerator(CharTable charTable, PinTable pinTable, GpioTable gpioTable)
    {
        _charTable = charTable;
        _pinTable = pinTable;
        _gpioTable = gpioTable;
        if (pinTable.Pins.Count != gpioTable.Gpios.Count)
            throw new Exception("pinTable.Pins.Count != gpioTable.Gpios.Count");
        ValidateCharTable();
    }

    private void ValidateCharTable()
    {
        foreach (var c in _charTable.Chars)
        {
            foreach (var segment in c.Segments)
            {
                for (var i = 1; i <= _pinTable.PositionsCount; i++)
                {
                    if (!_pinTable.SegmentExists(i, segment))
                        throw new Exception($"segment {i}{segment} does not exist in pin table");
                }
            }
        }
    }
    
    internal List<string> GenerateCharTable()
    {
        var output = new List<string>();

        foreach (var c in _charTable.Chars)
        {
            output.Add($"    // {c.Name}");
            output.Add("    {");
            for (var pos = 1; pos <= _pinTable.PositionsCount; pos++)
            {
                output.Add($"        // position {pos}");
                for (var com = 0; com < _pinTable.ComCount; com++)
                {
                    var o = GenerateCharTableLine(c, pos, com);
                    output.Add($"        {o} // com{com}");
                }
            }
            output.Add("    },");
        }
        return output;
    }

    private string GenerateCharTableLine(CharTable.LCDChar c, int pos, int com)
    {
        var output = new StringBuilder();
        for (var i = 0; i < _gpioTable.ByteCount; i++)
        {
            output.Append("0x");
            output.Append(GenerateByte(c, i, pos, com).ToString("X2"));
            if (pos == _pinTable.PositionsCount && com == _pinTable.ComCount - 1 && i == _gpioTable.ByteCount - 1)
                output.Append(' ');
            else
                output.Append(',');
        }
        return output.ToString();
    }

    private int GenerateByte(CharTable.LCDChar c, int byteNo, int pos, int com)
    {
        var b = 0;
        foreach (var segment in c.Segments)
        {
            var idx = 0;
            foreach (var pin in _pinTable.Pins)
            {
                var comPin = pin.ComPins[com];
                var io = _gpioTable.Gpios[idx];
                if (comPin.Pos == pos && comPin.SegmentName == segment && io.ByteNo == byteNo)
                    b |= 1 << io.BitNo;
                idx++;
            }
        }
        return b;
    }
}