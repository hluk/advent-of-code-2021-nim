import algorithm
import math
import sequtils
import tables

type HeightMap = seq[seq[int]]

proc parseHeightMap*(filename: string): HeightMap =
  var hm = filename.lines.toSeq.mapIt(9 & it.mapIt(it.ord - '0'.ord) & 9)
  let cols = hm[0].len
  newSeqWith[int](cols, 9) & hm & newSeqWith[int](cols, 9)

proc isLow(hm: HeightMap, r, c: int): bool =
  let x = hm[r][c]
  [(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)]
  .allIt(x < hm[r+it[0]][c+it[1]])

proc coords*(hm: HeightMap): seq[seq[int]] =
  let rows = hm.len
  let cols = hm[0].len
  [toSeq(1..rows-2), toSeq(1..cols-2)].product

proc riskLevel*(hm: HeightMap): int =
  let lows = hm.coords
  .filterIt(hm.isLow(it[0], it[1]))
  .mapIt(hm[it[0]][it[1]])
  lows.sum + lows.len

proc largestBasins*(hm: var HeightMap): int =
  let rows = hm.len
  let cols = hm[0].len
  var avail = 10
  for i in 0..rows.float.sqrt.int:
    for r in 1..rows-2:
      for c in 1..cols-2:
        let x = hm[r][c]
        if x == 9:
          continue

        let m = max([
          hm[r][c-1],
          hm[r][c+1],
          hm[r-1][c],
          hm[r+1][c],
        ])

        if m <= 9:
          hm[r][c] = avail
          inc avail
        else:
          hm[r][c] = m

  var c = hm.concat.toCountTable
  c.del(9)
  c.sort
  c.values.toSeq[0..2].foldl(a * b, 1)


if isMainModule:
  var hm = "input".parseHeightMap
  echo "Part1: ", hm.riskLevel
  echo "Part1: ", hm.largestBasins
