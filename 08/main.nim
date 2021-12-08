import sequtils
import sets
import strutils

type Signal = HashSet[char]
type Signals = seq[Signal]
type InOut = tuple[input: Signals, output: Signals]
type InOuts = seq[InOut]

proc parseInOutDigits(digits: string): Signals =
  digits.splitWhitespace.mapIt(it.toHashSet)

proc parseInOut*(filename: string): InOuts =
  filename.lines.toSeq
  .mapIt(it.split(" | ").mapIt(it.parseInOutDigits))
  .mapIt((input: it[0], output: it[1]))

template withLength(inputs: Signals, length: int, pred: untyped = true): Signal =
  let filtered = inputs.filterIt(it.len == length and pred)
  if filtered.len != 1:
    raise newException(
      ValueError, "Expected seq with length 1 got: " & filtered.repr)
  filtered[0]

proc decodeDigits*(io: InOut): int =
  var s: array[10, Signal]
  s[1] = io.input.withLength(2)
  s[7] = io.input.withLength(3)
  s[4] = io.input.withLength(4)
  s[8] = io.input.withLength(7)
  s[3] = io.input.withLength(5): (s[1] - it).len == 0
  s[6] = io.input.withLength(6): (it - s[1]).len == 5
  s[9] = s[3] + s[4]
  s[0] = s[8] - s[4] + s[1] + (s[9] - s[3])
  s[2] = s[8] - s[4] + (s[4] - s[0]) + (s[8] - s[6])
  s[5] = s[6] - (s[2] - s[3])

  io.output.mapIt(s.find(it)).join.parseInt

proc part2*(ios: InOuts): int =
  ios.foldl(decodeDigits(b) + a, 0)

proc part1*(ios: InOuts): int =
  ios.foldl(b.output.countIt(it.len in [2, 3, 4, 7]) + a, 0)

if isMainModule:
  let ios = parseInOut("input")
  echo "Part1: ", ios.part1
  echo "Part2: ", ios.part2
