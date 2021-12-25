import sequtils
import strutils
import tables
import zero_functional

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

proc toEast(p: Pos, map: Map): Pos =
  ((p.x + 1) mod map.w, p.y)

proc toSouth(p: Pos, map: Map): Pos =
  (p.x, (p.y + 1) mod map.h)

proc canMoveEast(p: Pos, map: Map): bool =
  p.toEast(map) notin map.m

proc canMoveSouth(p: Pos, map, map2: Map): bool =
  let p2 = p.toSouth(map)
  p2 notin map2.m and map.m.getOrDefault(p2) == East

proc part1*(map: Map): int =
  var map = map
  var map2: Map
  while true:
    map2 = Map(w: map.w, h: map.h)

    let east = map.m.pairs --> (p, c) --> filter(c == East).partition(p.canMoveEast(map))
    for (p, _) in east.yes:
      map2.m[p.toEast(map)] = East
    for (p, _) in east.no:
      map2.m[p] = East

    let south = map.m.pairs --> (p, c) --> filter(c == South).partition(p.canMoveSouth(map, map2))
    for (p, _) in south.yes:
      map2.m[p.toSouth(map)] = South
    for (p, _) in south.no:
      map2.m[p] = South

    map.swap(map2)

    inc result

    if east.yes.len == 0 and south.yes.len == 0:
      break

if isMainModule:
  let map = "input".parseMap
  echo "Part1: ", map.part1
