import algorithm
import tables
import zero_functional

type Pos = tuple[row: int8, col: int8]
type HeightMap = TableRef[Pos, uint16]

proc parseHeightMap*(filename: string): HeightMap =
  var hm = filename.lines --> map(it --> map(it.ord - '0'.ord))
  let rows = hm.len
  let cols = hm[0].len
  (0..<rows) --> combinations(0..<cols)
    .filter(hm[it[0]][it[1]] != 9)
    .map(((it[0].int8, it[1].int8), hm[it[0]][it[1]].uint16))
    .newTable

proc `+`(pos: Pos, d: (int, int)): Pos =
  (pos.row + d[0].int8, pos.col + d[1].int8)

proc `[]`(hm: HeightMap, pos: Pos): uint16 =
  hm.getOrDefault(pos, 9u16)

proc isLow(hm: HeightMap, pos: Pos, x: uint16): bool =
  [(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)] -->
    all(x < hm[pos + it])

proc riskLevel*(hm: HeightMap): int =
  hm.pairs --> filter(hm.isLow(it[0], it[1]))
  .fold(0, a + it[1].int + 1)

proc largestBasins*(hm: HeightMap): int =
  for (pos, x) in hm.mpairs:
    x = uint16(pos.row * hm.len + pos.col)

  var repeat = true
  while repeat:
    repeat = false
    for (pos, x) in hm.mpairs:
      let m = [(-1,0),(0,-1),(0,1),(1,0)] --> map(hm[pos + it]).max
      if x != m:
        x = m
        repeat = true

  var c = hm.values --> map(int).toCountTable
  c.sort
  c.values --> take(3) --> product()


if isMainModule:
  let hm = "input".parseHeightMap
  echo "Part1: ", hm.riskLevel
  echo "Part1: ", hm.largestBasins
