import sequtils
import strutils

let lines = "input".lines.toSeq
let binSize = len(lines[0])

let counts = lines.foldl(
  b.mapIt(it.ord - '0'.ord).zip(a).mapIt(it[0] + it[1]),
  newSeq[int](binSize))
let threshold = len(lines) div 2
let gamma = counts.mapIt(it div threshold).join.parseBinInt
let epsilon = counts.mapIt(1 - (it div threshold)).join.parseBinInt
echo "Part1: ", gamma * epsilon

template filter_lines(lines: seq[string], i: int, pred: untyped): seq[string] =
  if len(lines) > 1:
    let count {.inject.} = lines.countIt(it[i] == '1')
    let threshold {.inject.} = (len(lines) + 1) div 2
    let keepOnes = pred
    lines.filterIt((it[i] == '1') == keepOnes)
  else:
    lines

template part2(pred: untyped): int =
  (0..<binSize).foldl(filter_lines(a, b, pred), lines)[0].parseBinInt

let o2 = part2(count >= threshold)
let co2 = part2(count < threshold)
echo "Part1: ", o2 * co2
