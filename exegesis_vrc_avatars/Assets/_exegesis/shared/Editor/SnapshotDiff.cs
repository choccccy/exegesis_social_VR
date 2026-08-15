using System;
using System.Collections.Generic;
using System.Text;

namespace Exegesis.Shared
{
    /// <summary>
    /// Turns two ControllerSnapshot texts into something a person can act on.
    ///
    /// NUnit's own AreEqual message truncates around the first differing character, which on a
    /// snapshot this size reports a column number and a fragment of a float - true, and useless.
    /// This reports the line, the surrounding structure, and how much else differs, so the
    /// failure names the layer and state it happened in.
    ///
    /// Positional line comparison, not a real LCS diff. An inserted line makes everything after
    /// it read as different, which overstates the damage - but the first difference is still
    /// correct and still points at the right place, and that is what the message is for.
    /// </summary>
    public static class SnapshotDiff
    {
        public static string Describe(string expected, string actual, int contextBefore = 6,
                                      int maxReportedLines = 40)
        {
            var e = Split(expected);
            var a = Split(actual);

            int first = FirstDifference(e, a);
            if (first < 0) return "(the two snapshots are identical)";

            var sb = new StringBuilder();
            sb.AppendLine($"expected {e.Length} lines, actual {a.Length} lines; " +
                          $"{CountDifferingLines(e, a)} line(s) differ.");
            sb.AppendLine($"First difference at line {first + 1}:");
            sb.AppendLine();

            // Context is taken from the expected side; up to this point the two agree, so it
            // does not matter which one it comes from.
            for (int i = Math.Max(0, first - contextBefore); i < first; i++)
                sb.AppendLine($"  {i + 1,6}  {e[i]}");

            int shown = 0;
            for (int i = first; i < Math.Max(e.Length, a.Length) && shown < maxReportedLines; i++)
            {
                var le = i < e.Length ? e[i] : null;
                var la = i < a.Length ? a[i] : null;
                if (le == la)
                {
                    sb.AppendLine($"  {i + 1,6}  {le}");
                    continue;
                }

                if (le != null) sb.AppendLine($"- {i + 1,6}  {le}");
                if (la != null) sb.AppendLine($"+ {i + 1,6}  {la}");
                shown++;
            }

            if (shown >= maxReportedLines) sb.AppendLine("  ...  (further differences not shown)");

            return sb.ToString();
        }

        public static int FirstDifference(IReadOnlyList<string> e, IReadOnlyList<string> a)
        {
            int n = Math.Min(e.Count, a.Count);
            for (int i = 0; i < n; i++)
                if (!string.Equals(e[i], a[i], StringComparison.Ordinal)) return i;

            return e.Count == a.Count ? -1 : n;
        }

        public static int CountDifferingLines(IReadOnlyList<string> e, IReadOnlyList<string> a)
        {
            int n = Math.Min(e.Count, a.Count);
            int differing = Math.Abs(e.Count - a.Count);
            for (int i = 0; i < n; i++)
                if (!string.Equals(e[i], a[i], StringComparison.Ordinal)) differing++;

            return differing;
        }

        private static string[] Split(string text) =>
            (text ?? "").Replace("\r\n", "\n").Replace("\r", "\n").Split('\n');
    }
}
