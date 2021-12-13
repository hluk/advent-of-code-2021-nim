import math
import sequtils
import strscans
import strutils
import tables
import sets
import sugar

type Dots = Table[int, HashSet[int]]
type FoldAlong = (var Dots, int) -> void
type Fold = tuple[along: FoldAlong, value: int]
type Folds = seq[Fold]

proc foldAlongY(dots: var Dots, atY: int): void =
  dots.del(atY)
  for y in dots.keys.toSeq.filterIt(it > atY):
    let newY = 2 * atY - y
    dots.mgetOrPut(newY, initHashSet[int]()).incl(dots[y])
    dots.del(y)

proc foldAlongX(dots: var Dots, atX: int): void =
  for xs in dots.mvalues:
    xs = xs.filterIt(it != atX).mapIt(
      if it > atX: 2 * atX - it else: it
    ).toHashSet

proc foldAlong(axis: char): FoldAlong =
  if axis == 'x': foldAlongX
  elif axis == 'y': foldAlongY
  else: raise newException(ValueError, "Unexpected axis: " & axis)

proc `$`*(dots: Dots): string =
  toSeq(0..<6).map(
    y => toSeq(0..5*8-2).map(
      x => ".#"[dots.getOrDefault(y).contains(x).int]
    ).join
  ).join("\n")

proc parseDots(lines: string): Dots =
  for line in lines.splitLines:
    let (ok, x, y) = line.scanTuple("$i,$i")
    assert ok
    result.mgetOrPut(y, initHashSet[int]()).incl(x)

proc parseFold(line: string): Fold =
  let (ok, axis, value) = line.scanTuple("fold along $c=$i")
  assert ok
  (axis.foldAlong, value)

proc parseFolds(lines: string): Folds =
  lines.splitLines.map(parseFold)

proc parseInput*(filename: string): (Dots, Folds) =
  let lines = filename.readFile.strip.split("\n\n", 1)
  (lines[0].parseDots, lines[1].parseFolds)

proc foldDots*(dots: var Dots, folds: Folds): int =
  for fold in folds:
    fold.along(dots, fold.value)

  dots.values.toSeq.mapIt(it.len).sum

if isMainModule:
  var (dots, folds) = "input".parseInput
  echo "Part1: ", dots.foldDots(folds[0..0])
  discard dots.foldDots(folds[1..^1])
  echo "Part2:\n", dots
