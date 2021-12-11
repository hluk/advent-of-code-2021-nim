import zero_functional

type Map = array[10, array[10, uint8]]
type Pos = array[0..1, int]

proc `[]`(m: var Map, pos: Pos): var uint8 =
  m[pos[0]][pos[1]]

proc `[]=`(m: var Map, pos: Pos, value: uint8): void =
  m[pos[0]][pos[1]] = value

proc parseMap*(filename: string): Map =
  filename.readLines(10).pairs --> (r, line) --> foreach(
    line.pairs --> (c, v) --> foreach(
      result[[r, c]] = (v.ord - '0'.ord).uint8
    )
  )

proc flash(v: var uint8): bool =
  if v == 0:
    false
  elif v >= 9:
    v = 0
    true
  else:
    inc v
    false

proc flash(m: var Map, pos: Pos): int =
  if m[pos].flash:
    result = 1
    let r1 = max(0, pos[0] - 1)
    let r2 = min(9, pos[0] + 1)
    let c1 = max(0, pos[1] - 1)
    let c2 = min(9, pos[1] + 1)
    (r1..r2) --> combinations(c1..c2).foreach(result += m.flash(it))

proc step(m: var Map): int =
  m.mitems --> foreach(it.mitems --> foreach(inc it))

  0..9 --> combinations(0..9)
  .filter(m[it] == 10)
  .foreach(result += m.flash(it))

proc part1*(m: var Map): int =
  for i in 0..99:
    result += m.step

proc allFlashed(m: Map): bool =
  m --> all(it --> all(it == 0))

proc part2*(m: var Map): int =
  while not m.allFlashed:
    inc result
    discard m.step

if isMainModule:
  var m = "input".parseMap
  echo "Part1: ", m.part1
  echo "Part2: ", m.part2 + 100
