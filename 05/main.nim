import math
import strscans
import sequtils
import tables

proc segmentPoints(x1, y1, x2, y2: int): seq[(int, int)] =
  let xd = x2 - x1
  let yd = y2 - y1
  let xi = sgn(xd)
  let yi = sgn(yd)
  let lenght = max(abs(xd), abs(yd))
  return toSeq(0..lenght).mapIt((x1 + it * xi, y1 + it * yi))

template countOverlaps(vents: untyped): int =
  let points = vents.mapIt(
    segmentPoints(it.x1, it.y1, it.x2, it.y2).toSeq()
  ).concat
  newCountTable(points).values.toSeq.filterIt(it >= 2).len

let vents = stdin.lines.toSeq.mapIt(
  cast[tuple[ok: bool, x1, y1, x2, y2: int]](scanTuple(it, "$i,$i -> $i,$i"))
)

let vents1 = vents.filterIt(it.x1 == it.x2 or it.y1 == it.y2)
echo "Part1: ", countOverlaps(vents1)
echo "Part2: ", countOverlaps(vents)
