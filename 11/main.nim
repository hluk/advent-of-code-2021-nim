import algorithm
import sequtils

type Map = seq[seq[uint8]]
type Pos = seq[int]

const POSITIONS = product(@[toSeq(0..9), toSeq(0..9)])

proc `[]`(m: var Map, pos: Pos): var uint8 =
  m[pos[0]][pos[1]]

proc parseMap*(filename: string): Map =
  filename.lines.toSeq.mapIt(it.mapIt((it.ord - '0'.ord).uint8))

proc flash(v: var uint8): bool =
  if v == 0:
    false
  elif v >= 9:
    v = 0
    true
  else:
    inc v
    false

proc neighbors(pos: Pos): seq[Pos] =
  let r1 = max(0, pos[0] - 1)
  let r2 = min(9, pos[0] + 1)
  let c1 = max(0, pos[1] - 1)
  let c2 = min(9, pos[1] + 1)
  product(@[toSeq(r1..r2), toSeq(c1..c2)])

proc flash(m: var Map, pos: Pos): int =
  if m[pos].flash:
    neighbors(pos).foldl(a + m.flash(b), 1)
  else:
    0

proc step(m: var Map): int =
  for row in m.mitems:
    for v in row.mitems:
      inc v

  POSITIONS
  .filterIt(m[it] == 10)
  .foldl(a + m.flash(b), 0)

proc part1*(m: var Map): int =
  toSeq(0..99).foldl(a + m.step, 0)

proc allFlashed(m: Map): bool =
  m.allIt(it.allIt(it == 0))

proc part2*(m: var Map): int =
  while not m.allFlashed:
    inc result
    discard m.step

if isMainModule:
  var m = "input".parseMap
  echo "Part1: ", m.part1
  echo "Part2: ", m.part2 + 100
