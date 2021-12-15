import heapqueue
import sequtils

type Map = seq[seq[uint8]]
type RepeatedMap = object
  tile: seq[seq[uint8]]
  width*: int
  height*: int
type Pos = tuple[x: int, y: int]
type Risks = seq[seq[int]]

const INVALID = 999999
const VISITED = -1

proc `[]`(risks: Risks, pos: Pos): int =
  risks[pos.y][pos.x]

proc `[]=`(risks: var Risks, pos: Pos, value: int): void =
  risks[pos.y][pos.x] = value

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

iterator neighbors*(map: RepeatedMap, p: Pos): Pos =
  if 0 < p.x:
    yield (p.x-1, p.y)
  if p.x + 1 < map.width:
    yield (p.x+1, p.y)
  if 0 < p.y:
    yield (p.x, p.y-1)
  if p.y + 1 < map.height:
    yield (p.x, p.y+1)

func lowest(map: RepeatedMap, start, finish: Pos): int =
  var risks = newSeqWith(map.height, newSeqWith[int](map.width, INVALID))
  risks[start] = 0
  var heap = {0: start}.toHeapQueue
  while heap[0][1] != finish:
    let pos = heap.pop[1]
    for pos2 in map.neighbors(pos).toSeq.filterIt(risks[it] != VISITED):
      let risk = risks[pos] + map[pos2]
      if risk < risks[pos2]:
        risks[pos2] = risk
        heap.push((risk, pos2))
    risks[pos] = 0
  risks[finish]

proc lowest*(tile: Map, repeat: int = 1): int =
  let m = tile.toRepeated(repeat)
  m.lowest((0, 0), (m.width-1, m.height-1))

if isMainModule:
  let map = "input".parseMap
  echo "Part1: ", map.lowest
  echo "Part2: ", map.lowest(5)
