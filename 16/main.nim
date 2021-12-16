import sequtils
import strutils

type Packet = object
  version*: uint8
  id*: uint8
  literal*: int
  subpackets*: seq[Packet]

type Packets = seq[Packet]

const ID_SUM = 0
const ID_PRODUCT = 1
const ID_MIN = 2
const ID_MAX = 3
const ID_LITERAL = 4
const ID_GT = 5
const ID_LT = 6
const ID_EQ = 7

proc fromHex(c: char): int =
  if c.isDigit:
    c.ord - '0'.ord
  else:
    c.ord - 'A'.ord + 10

proc readPacketsData*(filename: string): string =
  filename.readLines(1)[0]

proc take(d: var string, len: int): string =
  result = d[0..<len]
  d = d[len..^1]

proc readData(d: var string): string =
  if d[0] == '1':
    d.take(5)[1..^1] & d.readData
  else:
    d.take(5)[1..^1]

proc parseSubPacketsData(d: var string, maxCount: int = -1): Packets =
  while d.len >= 4 and (maxCount == -1 or result.len < maxCount):
    var p: Packet

    p.version = fromBin[uint8](d.take(3))
    p.id = fromBin[uint8](d.take(3))

    if p.id == ID_LITERAL:
      p.literal = fromBin[int](d.readData)
    elif d.take(1) == "0":
      let len = fromBin[int](d.take(15))
      var d2 = d.take(len)
      p.subpackets = d2.parseSubPacketsData
    else:
      let maxSubPackets = fromBin[int](d.take(11))
      p.subpackets = d.parseSubPacketsData(maxSubPackets)

    result.add(p)

proc parsePacketData*(data: string): Packet =
  var d = data.mapIt(it.fromHex.toBin(4)).join
  d.parseSubPacketsData(1)[0]

proc part1(ps: Packets): int =
  ps.foldl(a + b.version.int + b.subpackets.part1, 0)

proc part1*(p: Packet): int =
  @[p].part1

proc part2*(p: Packet): int =
  case p.id:
  of ID_SUM: p.subpackets.foldl(a + b.part2, 0)
  of ID_PRODUCT: p.subpackets.foldl(a * b.part2, 1)
  of ID_MIN: p.subpackets.mapIt(it.part2).min
  of ID_MAX: p.subpackets.mapIt(it.part2).max
  of ID_LITERAL: p.literal
  of ID_GT:
    assert p.subpackets.len == 2
    (p.subpackets[0].part2 > p.subpackets[1].part2).int
  of ID_LT:
    assert p.subpackets.len == 2
    (p.subpackets[0].part2 < p.subpackets[1].part2).int
  of ID_EQ:
    assert p.subpackets.len == 2
    (p.subpackets[0].part2 == p.subpackets[1].part2).int
  else:
    raise newException(ValueError, "Unexpected type ID: " & $p.id)

if isMainModule:
  let packets = "input".readPacketsData.parsePacketData
  echo "Part1: ", packets.part1
  echo "Part2: ", packets.part2
