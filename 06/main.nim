import algorithm
import math
import sequtils
import strutils

type Timers = array[0..8, int]

proc run*(timers: Timers, days: int): int =
  var ts = timers
  for i in 0..<days:
    ts.rotateLeft(1)
    ts[6] += ts[8]
  ts.sum

proc parseTimers*(filename: string): Timers =
  let lines = filename.readLines(1)
  let timers = lines[0].split(",").map(parseInt)
  for t in timers:
    result[t] += 1

if isMainModule:
  let timers = parseTimers("input")
  echo "Part1: ", timers.run(80)
  echo "Part2: ", timers.run(256)
