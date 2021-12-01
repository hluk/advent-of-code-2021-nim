import sequtils
import strutils
import math

let contents = readFile("input").strip()
let ns = contents.splitLines().map(parseInt)

echo "Part1: ", zip(ns[0..^2], ns[1..^1]).countIt(it[0] < it[1])
echo "Part2: ", toSeq(3 ..< len(ns)).countIt(
  sum(ns[it - 3 .. it - 1]) < sum(ns[it - 2 .. it])
)
