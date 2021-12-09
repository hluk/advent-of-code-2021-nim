import math
import sequtils
import tables

type HeightMap = seq[seq[int]]
type Pos = tuple[row: int, col: int]

proc parseHeightMap*(filename: string): HeightMap =
  filename.lines.toSeq.mapIt(it.mapIt(it.ord - '0'.ord))

proc riskLevel*(hm: HeightMap, positions: seq[Pos]): int =
  positions.foldl(hm[b.row][b.col] + 1 + a, 0)

proc lowPositions*(hm: HeightMap): seq[Pos] =
  let rows = hm.len
  let cols = hm[0].len
  for r, row in hm:
    for c, col in row:
      let x = hm[r][c]
      if r > 0:
        if c > 0 and x >= hm[r-1][c-1]:
          continue
        if x >= hm[r-1][c]:
          continue
        if c + 1 < cols and x >= hm[r-1][c+1]:
          continue

      if c > 0 and x >= hm[r][c-1]:
        continue
      if c + 1 < cols and x >= hm[r][c+1]:
        continue

      if r + 1 < rows:
        if c > 0 and x >= hm[r+1][c-1]:
          continue
        if x >= hm[r+1][c]:
          continue
        if c + 1 < cols and x >= hm[r+1][c+1]:
          continue

      result.add((r, c))

proc largestBasins*(hm: var HeightMap): int =
  let rows = hm.len
  let cols = hm[0].len

  var avail = 10
  for i in 0..rows.float.sqrt.int:
    for r, row in hm:
      for c, col in row:
        let x = hm[r][c]
        if x == 9:
          continue

        var ns: seq[int]
        if r > 0:
          ns.add(hm[r-1][c])

        if c > 0:
          ns.add(hm[r][c-1])
        if c + 1 < cols:
          ns.add(hm[r][c+1])

        if r + 1 < rows:
          ns.add(hm[r+1][c])

        let m = max(ns)
        if 0 <= m and m <= 9:
          hm[r][c] = avail
          inc avail
        else:
          hm[r][c] = m

  var c = hm.concat.toCountTable
  c.del(9)
  c.sort
  let sizes = c.values.toSeq
  sizes[0..2].foldl(a * b, 1)


if isMainModule:
  var hm = "input".parseHeightMap
  echo "Part1: ", riskLevel(hm, hm.lowPositions)
  echo "Part1: ", hm.largestBasins
