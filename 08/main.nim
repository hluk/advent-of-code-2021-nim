import algorithm
import sequtils
import sets
import strutils

type Signals = seq[string]
type InOut = tuple[input: Signals, output: Signals]
type InOuts = seq[InOut]

proc parseInOutDigit*(digit: string): string =
  digit.sorted.join

proc parseInOutDigits*(digits: string): Signals =
  digits.splitWhitespace.mapIt(it.parseInOutDigit)

proc parseInOut*(filename: string): InOuts =
  filename.lines.toSeq.mapIt(it.split(" | ").mapIt(it.parseInOutDigits)).mapIt(
    (it[0], it[1])
  )

proc unique(xs: seq[HashSet[char]]): HashSet[char] =
  if xs.len != 1:
    raise newException(ValueError, "Expected seq with length 1 got: " & xs.repr)
  xs[0]

proc decodeDigits*(inout: InOut): int =
  let ds = inout[0].mapIt(it.toHashSet)
  let ls = ds.mapIt(it.len)

  let i1 = ls.find(2)
  let i7 = ls.find(3)
  let i4 = ls.find(4)
  let i8 = ls.find(7)

  var s: array[10, HashSet[char]]
  s[1] = ds[i1]
  s[7] = ds[i7]
  s[4] = ds[i4]
  s[8] = ds[i8]

  let s9x = s[4] + s[7]
  assert s9x.len == 5
  s[9] = ds.filterIt(
    it.len == 6 and (it - s9x).len == 1).unique
  s[0] = ds.filterIt(
    it.len == 6 and it != s[9] and (s[7] - it).len == 0).unique
  s[6] = ds.filterIt(
    it.len == 6 and it != s[9] and it != s[0]).unique

  let s2x = s[8] - s[9]
  assert s2x.len == 1
  s[2] = ds.filterIt(
    it.len == 5 and (s2x - it).len == 0).unique
  s[3] = ds.filterIt(
    it.len == 5 and (s[1] - it).len == 0).unique
  s[5] = ds.filterIt(
    it.len == 5 and it != s[2] and it != s[3]).unique

  inout[1].mapIt(s.find(it.toHashSet)).join.parseInt

proc part2*(inouts: InOuts): int =
  inouts.foldl(decodeDigits(b) + a, 0)

proc part1*(inouts: InOuts): int =
  inouts.foldl(b[1].countIt(
    it.len == 2 or it.len == 3 or it.len == 4 or it.len == 7) + a, 0)

if isMainModule:
  let inouts = parseInOut("input")
  echo "Part1: ", inouts.part1
  echo "Part2: ", inouts.part2
