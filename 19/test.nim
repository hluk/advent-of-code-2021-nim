import main
import unittest

suite "Day 19":
  test "part1":
    let scanners = "test1".parseScanners
    check scanners.part1 == 79

  test "part2":
    let scanners = "test1".parseScanners
    check scanners.part2 == 3621
