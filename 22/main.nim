import sequtils
import strscans

type
  FromTo = tuple[a, b: int]
  Range = tuple[x: FromTo, y: FromTo, z: FromTo]
  OpRange = tuple[op: bool, range: Range]
  OpRanges* = seq[OpRange]
  Ranges = seq[Range]

proc empty(r: Range): bool =
  r.x.b < r.x.a or
  r.y.b < r.y.a or
  r.z.b < r.z.a

proc count(r: Range): int =
  (r.x.b - r.x.a + 1) *
  (r.y.b - r.y.a + 1) *
  (r.z.b - r.z.a + 1)

proc count(rs: Ranges): int =
  rs.foldl(a + b.count, 0)

proc intersection(l, r: Range): Range =
  (
    (max(l.x.a, r.x.a), min(l.x.b, r.x.b)),
    (max(l.y.a, r.y.a), min(l.y.b, r.y.b)),
    (max(l.z.a, r.z.a), min(l.z.b, r.z.b)),
  )

proc intersections(rs: Ranges, r: Range): Ranges =
  rs.mapIt(it.intersection(r)).filterIt(not it.empty)

proc parseCubes*(line: string): OpRange =
  let (ok, op, x1, x2, y1, y2, z1, z2) = line.scanTuple("$w x=$i..$i,y=$i..$i,z=$i..$i")
  assert ok
  assert op in ["on", "off"]
  (op == "on", ((x1, x2), (y1, y2), (z1, z2)))

proc parseInput*(filename: string): OpRanges =
  filename.lines.toSeq.map(parseCubes)

proc rangesOnOff*(ops: OpRanges): (Ranges, Ranges) =
  var rOn: Ranges
  var rOff: Ranges
  for (op, range) in ops:
    if op:
      let rOff2 = rOn.intersections(range)
      let rOn2 = rOff.intersections(range)
      rOn.add(range)
      rOn &= rOn2
      rOff &= rOff2
    else:
      let rOff2 = rOn.intersections(range)
      let rOn2 = rOff.intersections(range)
      rOff &= rOff2
      rOn &= rOn2
  (rOn, rOff)

proc limited*(ops: OpRanges): OpRanges =
  let limit: Range = ((-50,50),(-50,50),(-50,50))
  ops.mapIt((it[0], it[1].intersection(limit))).filterIt(not it[1].empty)

proc count*(ops: OpRanges): int =
  let (rOn, rOff) = ops.rangesOnOff
  rOn.count - rOff.count

if isMainModule:
  let ops = "input".parseInput
  echo "Part1: ", ops.limited.count
  echo "Part2: ", ops.count
