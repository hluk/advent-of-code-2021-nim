import algorithm
import math
import sequtils
import tables

type Pos = (int, int)
type HeightMap = seq[seq[int]]

proc `+`(pos: Pos, d: (int, int)): Pos =
  (pos[0] + d[0], pos[1] + d[1])

proc `[]`(hm: HeightMap, pos: Pos): int =
  hm[pos[0]][pos[1]]

proc `[]=`(hm: var HeightMap, pos: Pos, value: int): void =
  hm[pos[0]][pos[1]] = value

proc parseHeightMap*(filename: string): HeightMap =
  var hm = filename.lines.toSeq.mapIt(9 & it.mapIt(it.ord - '0'.ord) & 9)
  let cols = hm[0].len
  newSeqWith[int](cols, 9) & hm & newSeqWith[int](cols, 9)

proc isLow(hm: HeightMap, pos: Pos): bool =
  let x = hm[pos]
  [(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)]
  .allIt(x < hm[pos + it])

proc coords*(hm: HeightMap): seq[Pos] =
  let rows = hm.len
  let cols = hm[0].len
  [toSeq(1..rows-2), toSeq(1..cols-2)].product
  .mapIt((it[0], it[1]))
  .filterIt(hm[it] != 9)
  .sorted

proc riskLevel*(hm: HeightMap): int =
  let lows = hm.coords
  .filterIt(hm.isLow(it))
  .mapIt(hm[it])
  lows.sum + lows.len

proc largestBasins*(hm: var HeightMap): int =
  let rows = hm.len
  var avail = 10
  let coords = hm.coords
  for i in 0..rows.float.sqrt.int:
    for pos in coords:
        let m = [(-1,0),(0,-1),(0,1),(1,0)].mapIt(hm[pos + it]).max
        if m <= 9:
          hm[pos] = avail
          inc avail
        else:
          hm[pos] = m

  var c = hm.concat.toCountTable
  c.del(9)
  c.sort
  c.values.toSeq[0..2].foldl(a * b, 1)

if isMainModule:
  var hm = "input".parseHeightMap
  echo "Part1: ", hm.riskLevel
  echo "Part1: ", hm.largestBasins
