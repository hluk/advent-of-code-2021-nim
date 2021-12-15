import sequtils

type Map = seq[seq[uint8]]
type Pos = tuple[x: int, y: int]
type Risks = seq[seq[int]]

const INVALID = 999999

proc `[]`(map: Risks, pos: Pos): int =
  if 0 <= pos.y and pos.y < map.len and 0 <= pos.x and pos.x < map[pos.y].len:
    map[pos.y][pos.x]
  else:
    INVALID

proc parseMap*(filename: string): Map =
  filename.lines.toSeq.mapIt:
    it.toSeq.mapIt:
      (it.ord - '0'.ord).uint8

proc risks*(map: Map): Risks =
  result = newSeqWith(map.len, newSeqWith[int](map[0].len, INVALID))

  let y0 = map.len - 1
  let x0 = map[y0].len - 1
  result[y0][x0] = map[y0][x0].int

  for i in 0..2:
    for y in countdown(y0, 0):
      for x in countdown(x0, 0):
        let m = [
          result[(x, y-1)],
          result[(x-1, y)],
          result[(x, y+1)],
          result[(x+1, y)]
        ].min + map[y][x].int
        result[y][x] = min(result[y][x], m)

proc lowest*(map: Map): int =
  map.risks[0][0] - map[0][0].int

proc enlarge*(tile: Map, rep: int = 5): Map =
  result = newSeqWith(tile.len * rep, newSeq[uint8](tile[0].len * rep))
  for (y, row) in result.mpairs:
    for (x, v) in row.mpairs:
      let u = tile[y mod tile.len][x mod tile[0].len]
      let d = (x div tile[0].len) + (y div tile.len)
      v = ((u + d.uint8 - 1) mod 9) + 1

proc lowest2*(tile: Map): int =
  tile.enlarge.lowest

if isMainModule:
  let map = "input".parseMap
  echo "Part1: ", map.lowest
  echo "Part2: ", map.lowest2
