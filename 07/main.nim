import algorithm
import math
import sequtils
import strutils

type Crabs = seq[int]

proc align*(crabs: Crabs, pos: int): int =
  crabs.mapIt(abs(it - pos)).sum

proc minFuelAlign*(crabs: Crabs): int =
  let mid = crabs.sorted[crabs.len div 2]
  crabs.align(mid)

proc sumUpTo*(a: int): int =
  (a + 1) * a div 2

proc align2*(crabs: Crabs, pos: int): int =
  crabs.mapIt(sumUpTo(abs(it - pos))).sum

proc minFuelAlign2*(crabs: Crabs): int =
  toSeq(min(crabs)..max(crabs)).mapIt(crabs.align2(it)).min

proc parseCrabs*(filename: string): Crabs =
  filename.readFile.strip.split(",").map(parseInt)

if isMainModule:
  let crabs = parseCrabs("input")
  echo "Part1: ", crabs.minFuelAlign
  echo "Part2: ", crabs.minFuelAlign2
