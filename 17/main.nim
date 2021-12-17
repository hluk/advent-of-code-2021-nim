import math
import sequtils
import strscans

type Area = tuple[x1, x2, y1, y2: int]
type Velocity = tuple[x, y: int]

proc parseTarget*(filename: string): Area =
  let (ok,x1,x2,y1,y2) = filename.readLines(1)[0]
  .scanTuple("target area: x=$i..$i, y=$i..$i")
  assert ok
  (x1, x2, y1, y2)

proc reach(target: Area, v0: Velocity): (bool, int) =
  # Calculate initial time when X is in the target range.
  let b: float = v0.x.float - 0.5
  let c: float = v0.x.float - target.x1.float
  let txx = b - sqrt(b^2 + 2*c)
  let tx = txx.ceil.int

  var y = (2 * v0.y - tx) * (tx + 1) div 2
  var x = (2 * v0.x - tx) * (tx + 1) div 2
  var v = (x: v0.x - tx, y: v0.y - tx)
  assert x >= target.x1

  while true:
    if x > target.x2 or y < target.y1:
      return (false, 0)

    if y <= target.y2:
      let maxY = v0.y * (v0.y + 1) div 2
      return (true, maxY)

    if v.x > 0: dec v.x
    dec v.y

    x += v.x
    y += v.y

iterator velocities(target: Area): Velocity =
  # The first x velocity time that can reach the target.
  let minX = sqrt(0.25 + 2 * target.x1.float) - 0.5
  for x in minX.ceil.int..target.x2:
    for y in countdown(100, target.y1):
      yield (x, y)

proc part1*(target: Area): int =
  for v in velocities(target):
    let (ok, y) = target.reach(v)
    if ok:
      return y

proc part2*(target: Area): int =
  velocities(target).countIt(target.reach(it)[0])

if isMainModule:
  let target = "input".parseTarget
  echo "Part1: ", target.part1
  echo "Part2: ", target.part2
