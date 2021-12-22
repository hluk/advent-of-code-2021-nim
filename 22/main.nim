import sequtils
import strscans

type
  FromTo = tuple[a, b: int]
  Range = tuple[x: FromTo, y: FromTo, z: FromTo]
  OpRange = tuple[op: bool, range: Range]
  OpRanges* = seq[OpRange]
  Ranges = seq[Range]

proc contains(l: Range, r: Range): bool =
  l.x.b >= r.x.a and
  l.y.b >= r.y.a and
  l.z.b >= r.z.a and
  l.x.a <= r.x.b and
  l.y.a <= r.y.b and
  l.z.a <= r.z.b

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

iterator intersections(rs: Ranges, r: Range): Range =
  for rx in rs:
    let ri = rx.intersection(r)
    if not ri.empty:
      yield ri

proc parseCubes*(line: string): OpRange =
  let (ok, op, x1, x2, y1, y2, z1, z2) = line.scanTuple("$w x=$i..$i,y=$i..$i,z=$i..$i")
  assert ok
  assert op in ["on", "off"]
  (op == "on", ((x1, x2), (y1, y2), (z1, z2)))

proc parseInput*(filename: string): OpRanges =
  filename.lines.toSeq.map(parseCubes)

proc part1*(ops: OpRanges): int =
  for x in -50..50:
    for y in -50..50:
      for z in -50..50:
        let r: Range = ((x,x), (y,y), (z,z))
        var enabled = false
        for (op, range) in ops:
          if op != enabled and range.contains(r):
            enabled = op
        result += enabled.ord

proc part2*(ops: OpRanges): int =
  var rOn: Ranges
  var rOff: Ranges
  for (op, range) in ops:
    if op:
      let rOff2 = rOn.intersections(range).toSeq
      let rOn2 = rOff.intersections(range).toSeq
      result += range.count - rOff2.count + rOn2.count
      rOn.add(range)
      rOn &= rOn2
      rOff &= rOff2
    else:
      let rOff2 = rOn.intersections(range).toSeq
      let rOn2 = rOff.intersections(range).toSeq
      result -= rOff2.count - rOn2.count
      rOff &= rOff2
      rOn &= rOn2

if isMainModule:
  let ops = "input".parseInput
  #echo "Part1: ", ops.part1
  echo "Part2: ", ops.part2
