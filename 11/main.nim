import sequtils
import zero_functional

type Map = seq[seq[uint8]]

proc parseMap*(filename: string): Map =
  filename.lines --> map(it --> map((it.ord - '0'.ord).uint8))

proc flash(m: var Map, r, c: int): int =
  if r < 0 or c < 0 or r >= m.len or c >= m[r].len or m[r][c] == 0:
    return 0

  inc m[r][c]
  if m[r][c] > 9:
    m[r][c] = 0
    inc result
    for (rd,cd) in [(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)]:
      let r1 = r+rd
      let c1 = c+cd
      result += m.flash(r1, c1)

proc step(m: var Map): int =
  for (r, row) in m.pairs:
    for (c, v) in row.pairs:
      inc m[r][c]

  for (r, row) in m.pairs:
    for (c, v) in row.pairs:
      if v == 10:
        result += m.flash(r, c)

proc part1*(m: var Map): int =
  for i in 0..99:
    result += m.step

proc allFlashed(m: Map): bool =
  for (r, row) in m.pairs:
    for (c, v) in row.pairs:
      if v != 0:
        return false
  return true


proc part2*(m: var Map): int =
  while not m.allFlashed:
    inc result
    discard m.step

if isMainModule:
  var m = "input".parseMap
  echo "Part1: ", m.part1
  echo "Part2: ", m.part2 + 100
