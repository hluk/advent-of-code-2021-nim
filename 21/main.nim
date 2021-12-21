import sequtils
import strscans
import tables

type
  Pos = uint8
  Player = tuple
    pos: Pos
    score: uint8
  Wins = (int64, int64)
  Cache = Table[(Player, Player), Wins]

proc swapped(a: Wins): Wins = (a[1], a[0])

proc `+=`(a: var Wins, b: Wins): void =
  a = (a[0] + b[0], a[1] + b[1])

proc parsePlayer*(line: string, player: int): Pos =
  let (ok, n, i) = line.scanTuple("Player $i starting position: $i")
  assert ok
  assert n == player
  i.uint8

proc parseInput*(filename: string): (Pos, Pos) =
  let lines = filename.lines.toSeq
  (
    lines[0].parsePlayer(1),
    lines[1].parsePlayer(2),
  )

proc part1*(p01, p02: Pos): (int, int) =
  var p1 = p01.int - 1
  var p2 = p02.int - 1
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

proc roll(cache: var Cache, p1, p2: Player, i: uint8 = 0, r: uint8 = 1): Wins =
  if i == 0 and r == 1 and (p1, p2) in cache:
    return cache[(p1, p2)]

  if r < 3:
    result += cache.roll(p1, p2, i, r+1)

  if i < 2:
    let p = (p1.pos + r, p1.score)
    result += cache.roll(p, p2, i+1)
  else:
    let newPos = (p1.pos + r) mod 10
    let p: Player = (newPos, p1.score + newPos + 1)
    if p.score >= 21:
      inc result[0]
    else:
      result += cache.roll(p2, p).swapped

  if i == 0 and r == 1:
    cache[(p1, p2)] = result

proc part2*(p01, p02: Pos): Wins =
  var cache: Cache
  let p1 = (p01 - 1, 0u8)
  let p2 = (p02 - 1, 0u8)
  cache.roll(p1, p2)

if isMainModule:
  let (p1, p2) = "input".parseInput
  let (m, roll) = part1(p1, p2)
  echo "Part1: ", m * roll

  let (w1, w2) = part2(p1, p2)
  echo "Part2: ", max(w1, w2)
