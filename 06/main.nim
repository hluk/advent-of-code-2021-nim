import math
import sequtils
import strutils

type Timers = array[9, int]

proc run*(timers: Timers, days: int): int =
  toSeq(0..<days).foldl(
    [a[1], a[2], a[3], a[4], a[5], a[6], a[7] + a[0], a[8], a[0]],
    timers
  ).sum

proc parseTimers*(filename: string): Timers =
  let timers = filename.readFile.strip.split(",")
  result = [0, 1, 2, 3, 4, 5, 6, 7, 8]
  result.applyIt(timers.count(it.intToStr))

if isMainModule:
  let timers = parseTimers("input")
  echo "Part1: ", timers.run(80)
  echo "Part2: ", timers.run(256)
