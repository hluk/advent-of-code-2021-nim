import algorithm
import math
import sequtils
import tables

proc pair(c: char): (int, int) =
    case c
    of '(': (1, 1)
    of ')': (1, -1)
    of '[': (2, 1)
    of ']': (2, -1)
    of '{': (3, 1)
    of '}': (3, -1)
    of '<': (4, 1)
    of '>': (4, -1)
    else: raise newException(ValueError, "Unexpected character: " & c)

proc score1(c: char): int =
    case c
    of ')': 3
    of ']': 57
    of '}': 1197
    of '>': 25137
    else: raise newException(ValueError, "Unexpected character: " & c)

proc part1*(filename: string): int =
  for line in filename.lines:
    var braces: seq[int]
    for c in line:
      let (i, d) = pair(c)
      if d == 1:
        braces.add(i)
      elif d == -1 and braces[^1] == i:
        discard braces.pop
      else:
        result += score1(c)
        break

proc part2*(filename: string): int =
  var scores: seq[int]
  for line in filename.lines:
    var braces: seq[int]
    for c in line:
      let (i, d) = pair(c)
      if d == 1:
        braces.add(i)
      elif d == -1 and braces[^1] == i:
        discard braces.pop
      else:
        braces.setLen(0)
        break
    if braces.len > 0:
      var score = 0
      for brace in braces.reversed:
        score = score * 5 + brace
      scores.add(score)

  scores.sort
  scores[scores.len div 2]

if isMainModule:
  echo "Part1: ", "input".part1
  echo "Part2: ", "input".part2
