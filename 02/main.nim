import sequtils
import strutils

var lines = "input".lines.toSeq
  .mapIt(it.split)
  .mapIt((it[0], it[1].parseInt))

var horizontal = lines.foldl(if b[0] == "forward": a + b[1] else: a, 0)
var depth = lines.foldl(
  if b[0] == "down": a + b[1]
  elif b[0] == "up": a - b[1]
  else: a, 0
)
echo "Part1: ", horizontal * depth

var depth_and_aim = lines.foldl(
  if b[0] == "down": (a[0], a[1] + b[1])
  elif b[0] == "up": (a[0], a[1] - b[1])
  else: (a[0] + a[1] * b[1], a[1]),
  (0, 0))
echo "Part2: ", horizontal * depth_and_aim[0]
