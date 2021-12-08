import main
import unittest

suite "day 8":
  test "part1":
    let inouts = parseInOut("test1")
    check inouts.part1 == 26

  test "decodeDigits":
    let inouts = parseInOut("test1")
    check decodeDigits(inouts[0]) == 8394
    check decodeDigits(inouts[1]) == 9781
    check decodeDigits(inouts[2]) == 1197
    check decodeDigits(inouts[3]) == 9361
    check decodeDigits(inouts[4]) == 4873
    check decodeDigits(inouts[5]) == 8418
    check decodeDigits(inouts[6]) == 4548
    check decodeDigits(inouts[7]) == 1625
    check decodeDigits(inouts[8]) == 8717
    check decodeDigits(inouts[9]) == 4315

  test "part2":
    let inouts = parseInOut("test1")
    check inouts.part2 == 61229
