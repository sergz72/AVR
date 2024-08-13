namespace LCDCharTableGenerator;

internal sealed class PinTable
{
    internal struct LCDComPin
    {
        internal int? Pos;
        internal string SegmentName;

        internal LCDComPin(string name)
        {
            if (name.Length < 2)
                throw new Exception($"too short pin name: {name}");
            if (char.IsDigit(name[0]))
            {
                Pos = name[0] - '0';
                SegmentName = name[1..];
            }
            else
            {
                Pos = null;
                SegmentName = name;
            }
        }

        internal LCDComPin(int pos, string name)
        {
            Pos = pos;
            SegmentName = name;
        }
    }
    
    internal sealed class LCDPin
    {
        internal readonly Dictionary<int, LCDComPin> ComPins;
        internal readonly int MaxPosition;
        
        internal LCDPin(List<int> comList, string line)
        {
            var parts = line.Split(' ');
            if (parts.Length != comList.Count)
                throw new Exception($"wrong pin table line column count: {line}");
            ComPins = [];
            var idx = 0;
            foreach (var com in comList)
                ComPins[com] = new LCDComPin(parts[idx++]);
            MaxPosition = ComPins.Max(p => p.Value.Pos ?? 0);
        }

        internal bool Contains(int pos, string segmentName)
        {
            return ComPins.ContainsValue(new LCDComPin(pos, segmentName));
        }
    }
    
    internal readonly List<LCDPin> Pins;
    internal readonly int PositionsCount;
    internal readonly int ComCount;
    
    internal PinTable(string fileName)
    {
        var lines = File.ReadAllLines(fileName);
        if (lines.Length < 2)
            throw new Exception("pin table file should contain at least 2 lines");

        var comList = new List<int>();
        var coms = lines[0].Split(' ');
        foreach (var com in coms)
        {
            if (com.Length != 4 || !com.StartsWith("COM") || !char.IsDigit(com[3]))
                throw new Exception($"wrong com definition line: {lines[0]}");
            comList.Add(com[3] - '0');
        }
        
        Pins = []; 
        for (var i = 1; i < lines.Length; i++)
            Pins.Add(new LCDPin(comList, lines[i]));

        PositionsCount = Pins.Max(p => p.MaxPosition);
        ComCount = coms.Length;
    }

    internal bool SegmentExists(int pos, string segmentName)
    {
        return Pins.Exists(p => p.Contains(pos, segmentName));   
    }
}