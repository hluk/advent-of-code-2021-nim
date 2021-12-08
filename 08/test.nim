import main
import unittest

suite "day 8":
  test "part1":
    let ios = parseInOut("test1")
    check ios.part1 == 26

  test "decodeDigits":
    let ios = parseInOut("test1")
    check decodeDigits(ios[0]) == 8394
    check decodeDigits(ios[1]) == 9781
    check decodeDigits(ios[2]) == 1197
    check decodeDigits(ios[3]) == 9361
    check decodeDigits(ios[4]) == 4873
    check decodeDigits(ios[5]) == 8418
    check decodeDigits(ios[6]) == 4548
    check decodeDigits(ios[7]) == 1625
    check decodeDigits(ios[8]) == 8717
    check decodeDigits(ios[9]) == 4315

  test "part2":
    let ios = parseInOut("test1")
    check ios.part2 == 61229
