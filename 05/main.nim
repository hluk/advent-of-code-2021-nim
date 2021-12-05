import math
import strutils
import sequtils
import tables

type Map = CountTable[(int, int)]

var map1 = Map()
var map2 = Map()

proc update(map: var Map, x1, y1, x2, y2: int): void =
  let xd = x2 - x1
  let yd = y2 - y1
  let xi = sgn(xd)
  let yi = sgn(yd)
  let lenght = max(abs(xd), abs(yd))
  for i in 0..lenght:
    map.inc((x1 + i * xi, y1 + i * yi))

for line in stdin.lines:
  let xs = line.splitWhitespace()

  let xy1 = xs[0].split(',').map(parseInt)
  let x1 = xy1[0]
  let y1 = xy1[1]

  assert xs[1] == "->"

  let xy2 = xs[2].split(',').map(parseInt)
  let x2 = xy2[0]
  let y2 = xy2[1]

  if x1 == x2 or y1 == y2:
    map1.update(x1, y1, x2, y2)
  map2.update(x1, y1, x2, y2)

for x in 0..9:
  echo toSeq(0..9).mapIt(map1[(it, x)]).join(" ")

var overlapCount = map1.values.toSeq.filterIt(it >= 2).len
echo "Part1: ", overlapCount

var overlapCount2 = map2.values.toSeq.filterIt(it >= 2).len
echo "Part2: ", overlapCount2
