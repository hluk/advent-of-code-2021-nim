import sequtils

type Map = seq[seq[uint8]]
type RepeatedMap = object
  tile: seq[seq[uint8]]
  width*: int
  height*: int
type Pos = tuple[x: int, y: int]
type Risks = seq[seq[int]]

const INVALID = 999999

proc `[]`(map: Risks, pos: Pos): int =
  if 0 <= pos.y and pos.y < map.len and 0 <= pos.x and pos.x < map[pos.y].len:
    map[pos.y][pos.x]
  else:
    INVALID

proc toRepeated*(tile: Map, repeat: int): RepeatedMap =
  RepeatedMap(
    tile: tile,
    width: tile[0].len * repeat,
    height: tile.len * repeat
  )

proc `[]`*(map: RepeatedMap, pos: Pos): int =
  let w = map.tile[0].len
  let h = map.tile.len
  let u = map.tile[pos.y mod h][pos.x mod w].int
  let d = (pos.x div w) + (pos.y div h)
  ((u + d - 1) mod 9) + 1

proc parseMap*(filename: string): Map =
  filename.lines.toSeq.mapIt:
    it.toSeq.mapIt:
      (it.ord - '0'.ord).uint8

proc risks*(map: RepeatedMap): Risks =
  result = newSeqWith(map.height, newSeqWith[int](map.width, INVALID))

  let y0 = map.height - 1
  let x0 = map.width - 1
  result[y0][x0] = map[(x0, y0)]

  for i in 0..2:
    for y in countdown(y0, 0):
      for x in countdown(x0, 0):
        let m = [
          result[(x, y-1)],
          result[(x-1, y)],
          result[(x, y+1)],
          result[(x+1, y)]
        ].min + map[(x, y)]
        result[y][x] = min(result[y][x], m)

proc lowest*(tile: Map, repeat: int = 1): int =
  tile.toRepeated(repeat).risks[0][0] - tile[0][0].int

if isMainModule:
  let map = "input".parseMap
  echo "Part1: ", map.lowest
  echo "Part2: ", map.lowest(5)
