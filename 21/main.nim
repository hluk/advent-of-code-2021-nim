import sequtils
import strscans
import tables

type Pos = int
type Cache = Table[(int, int, int, int, int, int, int), (int64, int64)]

proc parsePlayer*(line: string, player: int): Pos =
  let (ok, n, i) = line.scanTuple("Player $i starting position: $i")
  assert ok
  assert n == player
  i

proc parseInput*(filename: string): (Pos, Pos) =
  let lines = filename.lines.toSeq
  (
    lines[0].parsePlayer(1),
    lines[1].parsePlayer(2),
  )

proc part1*(p01, p02: int): (int, int) =
  var p1 = p01 - 1
  var p2 = p02 - 1
  var s1, s2, roll = 0
  while true:
    let r1 = (roll * 9 + 3) mod 100 + 3
    p1 = (p1 + r1) mod 10
    s1 += p1 + 1
    if s1 >= 1000:
      inc roll
      break

    roll += 2

    let r2 = (r1 + 6) mod 100 + 3
    p2 = (p2 + r2) mod 10
    s2 += p2 + 1
    if s2 >= 1000:
      break

  (min(s1, s2), roll*3)

proc roll(cache: var Cache, p, s: array[2, int], w: var array[2, int64], i: int = 0, j: int = 0, r: int = 1): void =
  let key = (p[0], p[1], s[0], s[1], i, j, r)
  if key in cache:
    let wd = cache[key]
    w[0] += wd[0]
    w[1] += wd[1]
    return

  let w0 = w

  var px = p
  px[i] += r
  if j == 2:
    px[i] = px[i] mod 10
    var sx = s
    sx[i] += px[i] + 1
    if sx[i] >= 21:
      inc w[i]
    else:
      cache.roll(px, sx, w, (i+1) mod 2)
  else:
    cache.roll(px, s, w, i, j+1)

  if r != 3:
    cache.roll(p, s, w, i, j, r+1)

  if w0 != w:
    cache[key] = (w[0] - w0[0], w[1] - w0[1])

proc part2*(p01, p02: int): (int64, int64) =
  let p = [p01 - 1, p02 - 1]
  let s = [0, 0]
  var w = [0i64, 0i64]
  var cache: Cache
  cache.roll(p, s, w)
  (w[0], w[1])

if isMainModule:
  let (p1, p2) = "input".parseInput
  let (m, roll) = part1(p1, p2)
  echo "Part1: ", m * roll

  let (w1, w2) = part2(p1, p2)
  echo "Part2: ", max(w1, w2)
