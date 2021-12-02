import sequtils
import strutils

var lines = "input".lines.toSeq
  .mapIt(it.split)
  .mapIt((dir: it[0], x: it[1].parseInt))

var horizontal = lines.foldl(if b.dir == "forward": a + b.x else: a, 0)
var depth = lines.foldl(
  if b.dir == "down": a + b.x
  elif b.dir == "up": a - b.x
  else: a, 0
)
echo "Part1: ", horizontal * depth

var depth_and_aim = lines.foldl(
  if b.dir == "down": (a.depth, a.aim + b.x)
  elif b.dir == "up": (a.depth, a.aim - b.x)
  else: (a.depth + a.aim * b.x, a.aim),
  (depth: 0, aim: 0))
echo "Part2: ", horizontal * depth_and_aim.depth
