import deques
import sequtils

type Map = seq[seq[int]]
type Pos = tuple[x: int, y: int]
type Risks = seq[seq[int]]

const INVALID = 999999

proc `[]`(map: Map, pos: Pos): int =
  if 0 <= pos.y and pos.y < map.len and 0 <= pos.x and pos.x < map[pos.y].len:
    map[pos.y][pos.x]
  else:
    INVALID

proc `[]=`(map: var Map, pos: Pos, value: int): void =
  map[pos.y][pos.x] = value

proc parseMap*(filename: string): Map =
  filename.lines.toSeq.mapIt(it.toSeq.mapIt(it.ord - '0'.ord))

iterator mapPositions(map: Map): Pos =
  var positions: Deque[Pos]
  let y = map.len - 1
  let x = map[y].len - 1
  positions.addLast((x, y))
  while positions.len != 0:
    let pos = positions.popFirst()
    if pos.x > 0 and not positions.contains((pos.x-1, pos.y)):
      positions.addLast((pos.x-1, pos.y))
    if pos.y > 0 and not positions.contains((pos.x, pos.y-1)):
      positions.addLast((pos.x, pos.y-1))
    yield pos

proc risks*(map: Map): Risks =
  result = newSeqWith(map.len, newSeq[int](map[0].len))

  for pos in map.mapPositions:
    let risk = map[pos]
    let m = min(result[(pos.x,pos.y+1)], result[(pos.x+1,pos.y)])
    if m == INVALID:
      result[pos] = risk
    else:
      result[pos] = risk + m

  for i in 0..1:
    for pos in map.mapPositions:
      let risk = map[pos]
      result[pos] = min([
        result[pos],
        risk + result[(pos.x,pos.y-1)],
        risk + result[(pos.x-1,pos.y)],
        risk + result[(pos.x,pos.y+1)],
        risk + result[(pos.x+1,pos.y)]
      ])

proc lowest*(map: Map): int =
  map.risks[0][0] - map[(0,0)]

proc enlarge*(tile: Map, rep: int = 5): Map =
  result = newSeqWith(tile.len * rep, newSeq[int](tile[0].len * rep))
  for (y, row) in result.mpairs:
    for (x, v) in row.mpairs:
      let u = tile[y mod tile.len][x mod tile[0].len]
      let d = (x div tile[0].len) + (y div tile.len)
      v = ((u + d - 1) mod 9) + 1

proc lowest2*(tile: Map): int =
  tile.enlarge.lowest

if isMainModule:
  let map = "input".parseMap
  echo "Part1: ", map.lowest
  echo "Part2: ", map.lowest2
