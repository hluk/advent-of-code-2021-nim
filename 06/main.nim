import math
import sequtils
import strutils

type Timers = array[0..8, int]

proc run*(timers: Timers, days: int): int =
  var ts = timers
  for i in 0..<days:
    ts[(i + 7) mod 9] += ts[i mod 9]
  ts.sum

proc parseTimers*(filename: string): Timers =
  let timers = filename.readFile.strip.split(",")
  result = [0, 1, 2, 3, 4, 5, 6, 7, 8]
  result.applyIt(timers.count(it.intToStr))

if isMainModule:
  let timers = parseTimers("input")
  echo "Part1: ", timers.run(80)
  echo "Part2: ", timers.run(256)
