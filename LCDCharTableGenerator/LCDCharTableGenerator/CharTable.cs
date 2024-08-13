namespace LCDCharTableGenerator;

internal sealed class CharTable
{
    internal sealed class LCDChar
    {
        internal readonly string[] Segments;
        internal readonly string Name;
        
        internal LCDChar(string line)
        {
            var parts = line.Split(' ');
            if (parts.Length != 2)
                throw new Exception($"wrong char table line format: {line}");
            Name = parts[0];
            Segments = parts[1].Split(',');
        }
    }
    
    internal readonly List<LCDChar> Chars;
    
    internal CharTable(string fileName)
    {
        var lines = File.ReadAllLines(fileName);
        Chars = []; 
        foreach (var line in lines)
            Chars.Add(new LCDChar(line));
    }
}