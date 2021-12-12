import main
import unittest

suite "day 11":
  test "part1":
    var p = "test1".parsePaths
    check p.paths == 10

  test "part1.2":
    var p = "test2".parsePaths
    check p.paths == 19

  test "part1.3":
    var p = "test3".parsePaths
    check p.paths == 226

  test "part2":
    var p = "test1".parsePaths
    check p.paths2 == 36

  test "part2.2":
    var p = "test2".parsePaths
    check p.paths2 == 103

  test "part2.3":
    var p = "test3".parsePaths
    check p.paths2 == 3509
