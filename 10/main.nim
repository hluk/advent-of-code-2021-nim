import algorithm
import zero_functional

const PAIRS = "()[]{}<>"

proc value(c: char): int =
  PAIRS.find(c) div 2 + 1

proc isOpening(c: char): bool =
  PAIRS.find(c) mod 2 == 0

proc score(c: char): int =
  case c
  of ')': 3
  of ']': 57
  of '}': 1197
  of '>': 25137
  else: raise newException(ValueError, "Unexpected character: " & c)

proc unclosed(line: string, i: int = 0, expect: seq[int] = newSeq[int]()): (int, int) =
    if i >= line.len:
      return (0, expect.reversed --> fold(0, a * 5 + it))

    if isOpening(line[i]):
      unclosed(line, i + 1, expect & value(line[i]))
    elif expect[^1] == value(line[i]):
      unclosed(line, i + 1, expect[0..^2])
    else:
      (score(line[i]), 0)

proc solve*(filename: string): (int, int) =
  var scores = filename.lines --> map(unclosed)
  let part1 = scores --> fold(0, a + it[0])
  let part2 = scores --> map(it[1]) --> filter(it != 0) --> sorted
  (part1, part2[part2.len div 2])

proc part2*(filename: string): int =
  var scores = filename.lines --> map(unclosed(it)[1]).filter(it != 0)
  scores.sort
  scores[scores.len div 2]

if isMainModule:
  echo "input".solve
