import strscans

type Area = tuple[x1, x2, y1, y2: int]

proc parseTarget*(filename: string): Area =
  let (ok,x1,x2,y1,y2) = filename.readLines(1)[0]
  .scanTuple("target area: x=$i..$i, y=$i..$i")
  assert ok
  (x1, x2, y1, y2)

proc reach(t: Area, vx0, vy0: int, maxYTotal: int): (bool, int) =
  var vx = vx0
  var vy = vy0
  var x, y: int
  var maxY = 0
  while true:
    x += vx
    y += vy
    maxY = max(maxY, y)
    if t.x1 <= x and x <= t.x2 and t.y1 <= y and y <= t.y2:
      return (true, maxY)
    if x > t.x2 or y <= t.y1 or (vx <= 0 and x < t.x1):
      return (false, 0)
    if vy <= 0 and maxY < maxYTotal:
      return (false, 0)
    if vx > 0:
      dec vx
    dec vy

proc part1*(target: Area): int =
  for x in 1..1000:
    for y in -1000..1000:
      let (ok, maxY) = target.reach(x, y, result)
      if ok and maxY > result:
        result = maxY

proc part2*(target: Area): int =
  for x in 1..1000:
    for y in -1000..1000:
      let (ok, _) = target.reach(x, y, int.low)
      if ok:
        inc result

if isMainModule:
  let target = "input".parseTarget
  echo "Part1: ", target.part1
  echo "Part2: ", target.part2
