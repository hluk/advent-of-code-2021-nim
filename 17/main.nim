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
  var v = v0
  var x, y: int

  while true:
    x += v.x
    y += v.y

    if target.x1 <= x and x <= target.x2 and target.y1 <= y and y <= target.y2:
      let maxY = v0.y * (v0.y + 1) div 2
      return (true, maxY)

    if x > target.x2 or y <= target.y1 or (v.x <= 0 and x < target.x1):
      return (false, 0)

    if v.x > 0: dec v.x
    dec v.y

iterator velocities(target: Area): Velocity =
  for x in 1..target.x2:
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
