import math
import sequtils
import sets
import strscans
import strutils
import tables

type Pos = array[3, int]
type Rot = Pos
type Scanner = seq[Pos]
type Scanners = seq[Scanner]

const MIN_BEACON_OVERLAP = 12
const ROTATIONS: array[24, Rot] = [
  [1, 2, 3],
  [1,-3, 2],
  [1,-2,-3],
  [1, 3,-2],
  [2, 3, 1],
  [2,-1, 3],
  [2,-3,-1],
  [2, 1,-3],
  [3, 1, 2],
  [3,-2, 1],
  [3,-1,-2],
  [3, 2,-1],
  [-3,-2,-1],
  [-3, 1,-2],
  [-3, 2, 1],
  [-3,-1, 2],
  [-2,-1,-3],
  [-2, 3,-1],
  [-2, 1, 3],
  [-2,-3, 1],
  [-1,-3,-2],
  [-1, 2,-3],
  [-1, 3, 2],
  [-1,-2, 3],
]

proc `-`*(a: Pos): Pos =
  [-a[0], -a[1], -a[2]]

proc `-`*(a: Pos, b: Pos): Pos =
  [a[0] - b[0], a[1] - b[1], a[2] - b[2]]

proc `+`*(a: Pos, b: Pos): Pos =
  [a[0] + b[0], a[1] + b[1], a[2] + b[2]]

proc manhattan*(a: Pos, b: Pos): int =
  abs(a[0] - b[0]) + abs(a[1] - b[1]) + abs(a[2] - b[2])

proc parsePos*(posString: string): Pos =
  let (ok, x, y, z) = posString.scanTuple("$i,$i,$i")
  assert ok
  [x, y, z]

proc parseScanner*(scannerString: string): Scanner =
  scannerString.strip.splitLines[1..^1].map(parsePos)

proc parseScanners*(filename: string): Scanners =
  filename.readFile.split("\n\n").map(parseScanner)

proc rotated(p: Pos, r: Rot): Pos =
  [
    p[r[0].abs - 1] * r[0].sgn,
    p[r[1].abs - 1] * r[1].sgn,
    p[r[2].abs - 1] * r[2].sgn,
  ]

proc findRelativePosRot(a: Scanner, b: Scanner): (bool, Pos, Rot) =
  for r in ROTATIONS:
    var diffs: CountTable[Pos]
    for p1 in a:
      for p2 in b:
        let d = p1 - p2.rotated(r)
        diffs.inc(d)
        if diffs[d] == MIN_BEACON_OVERLAP:
          return (true, d, r)

  result[0] = false

proc findPath(relations: seq[Table[int, (Pos, Rot)]], j: int, path: var seq[int]): bool =
  if j in path:
    return false

  path.add(j)

  if j == 0:
    return true

  for i in relations[j].keys:
    if relations.findPath(i, path):
      return true

  discard path.pop()

  return false

proc solution*(scanners: Scanners): (int, int) =
  let l = scanners.len
  var relations = newSeqWith(l, initTable[int, (Pos, Rot)]())
  for i in 0..<l-1:
    let a = scanners[i]
    for j in i+1..<l:
      let b = scanners[j]
      let (found, p, r) = findRelativePosRot(a, b)
      if found:
        relations[j][i] = (p, r)
        if i != 0:
          var rr: Rot
          rr[r[0].abs - 1] = 1 * r[0].sgn
          rr[r[1].abs - 1] = 2 * r[1].sgn
          rr[r[2].abs - 1] = 3 * r[2].sgn
          relations[i][j] = ((-p).rotated(rr), rr)

  var paths = newSeqWith(l, newSeq[int]())
  for j in 1..<l:
    discard relations.findPath(j, paths[j])

  var s = scanners
  var origins = newSeqWith[Pos](l, [0,0,0])
  for j in 1..<l:
    let path = paths[j]
    for i in 0..path.len-2:
      let (p, r) = relations[path[i]][path[i+1]]
      s[j].applyIt(it.rotated(r) + p)
      origins[j] = origins[j].rotated(r) + p

  result[0] = s.concat.toHashSet.len

  for i in 0..<l:
    for j in i+1..<l:
      result[1] = max(result[1], manhattan(origins[i], origins[j]))

if isMainModule:
  let scanners = "input".parseScanners
  echo scanners.solution
