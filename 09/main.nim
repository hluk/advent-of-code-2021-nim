import algorithm
import math
import sequtils
import tables

type Pos = tuple[row: int, col: int]
type HeightMap = TableRef[Pos, int]

proc parseHeightMap*(filename: string): HeightMap =
  var hm = filename.lines.toSeq.mapIt(it.mapIt(it.ord - '0'.ord))
  let rows = hm.len
  let cols = hm[0].len
  [toSeq(0..rows-1), toSeq(0..cols-1)].product
  .filterIt(hm[it[0]][it[1]] != 9)
  .mapIt(((it[0], it[1]), hm[it[0]][it[1]]))
  .newTable

proc `+`(pos: Pos, d: (int, int)): Pos =
  (pos.row + d[0], pos.col + d[1])

proc `[]`(hm: HeightMap, pos: Pos): int =
  hm.getOrDefault(pos, 9)

proc isLow(hm: HeightMap, pos: Pos, x: int): bool =
  [(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)]
  .allIt(x < hm[pos + it])

proc riskLevel*(hm: HeightMap): int =
  let lows = hm.pairs.toSeq
  .filterIt(hm.isLow(it[0], it[1]))
  .mapIt(it[1])
  lows.sum + lows.len

proc largestBasins*(hm: var HeightMap): int =
  var avail = 10
  for (pos, x) in hm.mpairs:
    x = [(-1,0),(0,-1),(0,1),(1,0)].mapIt(hm[pos + it]).max
    if x <= 9:
      x = avail
      inc avail

  var changed = true
  while changed:
    changed = false
    for (pos, x) in hm.mpairs:
      var m = [(-1,0),(0,-1),(0,1),(1,0)].mapIt(hm[pos + it]).max
      if x != m:
        x = m
        changed = true

  var c = hm.values.toSeq.mapIt(it).toCountTable
  c.sort
  c.values.toSeq[0..2].foldl(a * b, 1)


if isMainModule:
  var hm = "input".parseHeightMap
  echo "Part1: ", hm.riskLevel
  echo "Part1: ", hm.largestBasins
