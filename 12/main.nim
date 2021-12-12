import strutils
import tables

type Paths = Table[string, seq[string]]
type Visited = seq[string]

proc parsePaths*(filename: string): Paths =
  for line in filename.lines:
    let path = line.split("-")
    result.mgetOrPut(path[0], @[]).add(path[1])
    result.mgetOrPut(path[1], @[]).add(path[0])

proc canVisitAgain(cave: string): bool =
  cave[0].isUpperAscii

proc visit(p: Paths, c: string, visited: var Visited, visitedTwice: bool): int =
  visited.add(c)
  for s in p.getOrDefault(c):
    if s == "end":
      result += 1
    elif s.canVisitAgain or not visited.contains(s):
      result += p.visit(s, visited, visitedTwice)
    elif s != "start" and not visitedTwice:
      result += p.visit(s, visited, true)
  discard visited.pop()

proc paths*(p: Paths): int =
  var visited: Visited
  p.visit("start", visited, true)

proc paths2*(p: Paths): int =
  var visited: Visited
  p.visit("start", visited, false)

if isMainModule:
  var p = "input".parsePaths
  echo "Part1: ", p.paths
  echo "Part1: ", p.paths2
