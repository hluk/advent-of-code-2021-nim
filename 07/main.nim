import algorithm
import math
import sequtils
import strutils

type Crabs = seq[int]

proc align*(crabs: Crabs, pos: int): int =
  crabs.foldl(abs(b - pos) + a, 0)

proc minFuelAlign*(crabs: Crabs): int =
  let mid = crabs.sorted[crabs.len div 2]
  crabs.align(mid)

proc sumUpTo2*(a: int): int =
  (a + 1) * a

proc align2*(crabs: Crabs, pos: int): int =
  crabs.foldl(sumUpTo2(abs(b - pos)) + a, 0) div 2

proc minFuelAlign2*(crabs: Crabs): int =
  let mean = crabs.sum / crabs.len
  {mean.floor.int, mean.ceil.int}.mapIt(crabs.align2(it)).min

proc parseCrabs*(filename: string): Crabs =
  filename.readFile.strip.split(",").map(parseInt)

if isMainModule:
  let crabs = parseCrabs("input")
  echo "Part1: ", crabs.minFuelAlign
  echo "Part2: ", crabs.minFuelAlign2
