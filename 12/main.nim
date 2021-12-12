import strutils
import sets
import tables

type Paths = Table[string, seq[string]]
type Visited = seq[string]
type UniquePaths = HashSet[Visited]

proc addPath(paths: var Paths, a: string, b: string): void =
  if paths.hasKey(a):
    paths[a].add(b)
  else:
    paths[a] = @[b]

proc parsePaths*(filename: string): Paths =
  for line in filename.lines:
    let path = line.split("-")
    result.addPath(path[0], path[1])
    result.addPath(path[1], path[0])

proc canVisitAgain(cave: string): bool =
  cave[0].isUpperAscii

proc visit(p: Paths, c: string, visited: var Visited, paths: var UniquePaths): void =
  visited.add(c)
  #echo "+", c
  for s in p.getOrDefault(c):
    if s == "end":
      #echo "++", visited
      paths.incl(visited)
    elif s.canVisitAgain or not visited.contains(s):
      p.visit(s, visited, paths)
  #echo "-", c
  discard visited.pop()

proc paths*(p: Paths): int =
  #echo p
  var visited: Visited
  var paths: UniquePaths
  p.visit("start", visited, paths)
  #echo paths
  paths.len

proc visit2(p: Paths, c: string, visited: var Visited, paths: var UniquePaths, visitedTwice: string): void =
  visited.add(c)
  #echo "+", c
  for s in p.getOrDefault(c):
    if s == "end":
      #echo "++", visited
      paths.incl(visited)
    elif s.canVisitAgain or not visited.contains(s):
      p.visit2(s, visited, paths, visitedTwice)
    elif s != "start" and visitedTwice.len == 0:
      p.visit2(s, visited, paths, s)
  #echo "-", c
  discard visited.pop()

proc paths2*(p: Paths): int =
  #echo p
  var visited: Visited
  var paths: UniquePaths
  p.visit2("start", visited, paths, "")
  #echo paths
  paths.len

if isMainModule:
  var p = "input".parsePaths
  echo "Part1: ", p.paths
  echo "Part1: ", p.paths2
