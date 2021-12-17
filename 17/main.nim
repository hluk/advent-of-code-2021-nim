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

proc timeTo(x: int, v: int, s: float): int =
  let b: float = v.float - 0.5
  let c: float = v.float - x.float
  let t = b + s * sqrt(b^2 + 2*c)
  t.ceil.int

proc reach(target: Area, v0: Velocity): (bool, int) =
  # Calculate initial time when X and Y is in the target range.
  let tx = timeTo(target.x1, v0.x, -1)
  let ty = timeTo(target.y2, v0.y, 1)

  let t = max(tx, ty)
  let y = (2 * v0.y - t) * (t + 1) div 2
  let tx0 = min(v0.x, t)
  let x = (2 * v0.x - tx0) * (tx0 + 1) div 2

  if x > target.x2 or y < target.y1:
    return (false, 0)

  let maxY = v0.y * (v0.y + 1) div 2
  return (true, maxY)

iterator velocities(target: Area): Velocity =
  # The smallest x velocity time that can reach the target.
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
