import strutils
import tables

type Path = uint8
type Paths = Table[Path, seq[Path]]
type Visited = seq[Path]

const START: Path = 0
const END: Path = 1
const FIRST_LARGE_CAVE_ID: Path = 100

proc parsePaths*(filename: string): Paths =
  var caveIds: Table[string, Path]
  var availableId: Path = 2
  caveIds["start"] = START
  caveIds["end"] = END

  for line in filename.lines:
    let path = line.split("-", 1)
    let ax: Path = if path[0][0].isUpperAscii: 100 else: 0
    let bx: Path = if path[1][0].isUpperAscii: 100 else: 0
    let a = caveIds.mgetOrPut(path[0], availableId + ax)
    let b = caveIds.mgetOrPut(path[1], availableId + 1 + bx)
    result.mgetOrPut(a, @[]).add(b)
    result.mgetOrPut(b, @[]).add(a)
    availableId += 2

proc visit(p: Paths, c: Path, visited: var Visited, visitedTwice: bool): int =
  visited.add(c)
  for s in p.getOrDefault(c):
    if s == END:
      result += 1
    elif s >= FIRST_LARGE_CAVE_ID or not visited.contains(s):
      result += p.visit(s, visited, visitedTwice)
    elif s != START and not visitedTwice:
      result += p.visit(s, visited, true)
  discard visited.pop()

proc paths*(p: Paths): int =
  var visited: Visited
  p.visit(START, visited, true)

proc paths2*(p: Paths): int =
  var visited: Visited
  p.visit(START, visited, false)

if isMainModule:
  var p = "input".parsePaths
  echo "Part1: ", p.paths
  echo "Part1: ", p.paths2
