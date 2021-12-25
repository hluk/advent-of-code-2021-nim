import sequtils
import strutils
import tables

type
  Cucumber = enum East South
  Pos = tuple[x, y: int]
  Map = object
    w, h: int
    m: Table[Pos, Cucumber]

proc toCucumber(c: char): Cucumber =
  if c == '>': East
  else: South

proc parseMap*(filename: string): Map =
  var lines = filename.lines.toSeq
  result.h = lines.len
  result.w = lines[0].len
  for y, line in lines:
    for x, c in line:
      if c != '.':
        result.m[(x, y)] = c.toCucumber

proc toChar(c: Cucumber): char =
  if c == East: '>'
  else: 'v'

proc `$`(map: Map): string =
  result = ('.'.repeat(map.w) & '\n').repeat(map.h)
  for p, c in map.m:
    result[p.y * (map.w + 1) + p.x] = c.toChar

proc part1*(map: Map): int =
  var moved = true
  var map = map
  var map2: Map
  while moved:
    moved = false
    map2 = Map(w: map.w, h: map.h)

    #echo result
    #echo map

    for p, c in map.m:
      if c == East:
        var p2 = ((p.x + 1) mod map.w, p.y)
        if p2 notin map.m:
          map2.m[p2] = c
          moved = true
        else:
          map2.m[p] = c

    for p, c in map.m:
      if c == South:
        var p2 = (p.x, (p.y + 1) mod map.h)
        if p2 notin map2.m and (p2 notin map.m or map.m[p2] == East):
          map2.m[p2] = c
          moved = true
        else:
          map2.m[p] = c

    map.swap(map2)

    inc result

if isMainModule:
  let map = "input".parseMap
  echo "Part1: ", map.part1
