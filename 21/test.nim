import main
import unittest

suite "Day 21":
  test "parseInput":
    var (p1, p2) = "test1".parseInput
    check (p1, p2) == (4, 8)

  test "part1":
    var (p1, p2) = "test1".parseInput
    check part1(p1, p2) == (745, 993)

  test "part2":
    var (p1, p2) = "test1".parseInput
    check part2(p1, p2) == (444356092776315, 341960390180808)
