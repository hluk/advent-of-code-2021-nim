import math
import strscans
import sequtils
import tables

type
  Vent = tuple[valid: bool, x1, y1, x2, y2: int]
  Vents = seq[Vent]

proc segmentPoints*(l: Vent): seq[(int, int)] =
  assert l.valid
  let xd = l.x2 - l.x1
  let yd = l.y2 - l.y1
  let xi = sgn(xd)
  let yi = sgn(yd)
  let lenght = max(abs(xd), abs(yd))
  return toSeq(0..lenght).mapIt((l.x1 + it * xi, l.y1 + it * yi))

proc countOverlaps*(vents: Vents): int =
  let points = vents.mapIt(segmentPoints(it)).concat
  newCountTable(points).values.toSeq.filterIt(it >= 2).len

proc parseVents*(filename: string): Vents =
  filename.lines.toSeq.mapIt(scanTuple(it, "$i,$i -> $i,$i"))

proc onlyNondiagonal*(vents: Vents): Vents =
  vents.filterIt(it.x1 == it.x2 or it.y1 == it.y2)

if isMainModule:
  let vents = parseVents("input")
  echo "Part1: ", countOverlaps(onlyNondiagonal(vents))
  echo "Part2: ", countOverlaps(vents)
