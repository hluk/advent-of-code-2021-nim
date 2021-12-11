import main
import unittest

suite "day 11":
  test "part1":
    var m = "test1".parseMap
    check m.part1 == 1656

  test "part2":
    var m = "test1".parseMap
    check m.part2 == 195
