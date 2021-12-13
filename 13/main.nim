import math
import sequtils
import strscans
import strutils
import tables
import sets
import sugar

type Dots = Table[int, HashSet[int]]
type FoldAlong = enum alongX, alongY
type Fold = tuple[along: FoldAlong, value: int]
type Folds = seq[Fold]

proc `$`*(dots: Dots): string =
  toSeq(0..<6).map(
    (y) => toSeq(0..5*8-2).map(
      (x) => (if dots.getOrDefault(y).contains(x): '#' else: '.')
    ).join
  ).join("\n")

proc parseInput*(filename: string): (Dots, Folds) =
  var readDots = true
  for line in filename.lines:
    if line.len == 0:
      readDots = false
    elif readDots:
      let (ok, x, y) = line.scanTuple("$i,$i")
      assert ok
      result[0].mgetOrPut(y, initHashSet[int]()).incl(x)
    else:
      let (ok, alongName, value) = line.scanTuple("fold along $w=$i")
      assert ok
      assert alongName == "x" or alongName == "y"
      let along = if alongName == "x": alongX else: alongY
      result[1].add((along, value))

proc foldDots*(dots: var Dots, folds: Folds): int =
  for fold in folds:
    if fold.along == alongY:
      dots.del(fold.value)
      for y in dots.keys.toSeq:
        if y > fold.value:
          let newY = 2 * fold.value - y
          dots.mgetOrPut(newY, initHashSet[int]()).incl(dots[y])
          dots.del(y)
    else:
      for (y, xs) in dots.mpairs:
        for x in xs.toSeq:
          if x == fold.value:
            xs.excl(x)
          elif x > fold.value:
            xs.excl(x)
            let newX = 2 * fold.value - x
            xs.incl(newX)

  dots.values.toSeq.mapIt(it.len).sum

if isMainModule:
  var (dots, folds) = "input".parseInput
  echo "Part1: ", dots.foldDots(folds[0..0])
  discard dots.foldDots(folds[1..^1])
  echo "Part2:\n", dots
