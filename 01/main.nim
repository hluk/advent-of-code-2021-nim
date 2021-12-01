import sequtils
import strutils
import math

let ns = "input".lines.toSeq.map(parseInt)

echo "Part1: ", zip(ns, ns[1..^1]).countIt(it[0] < it[1])
echo "Part2: ", countIt(3 ..< len(ns),
  sum(ns[it - 3 .. it - 1]) < sum(ns[it - 2 .. it])
)
