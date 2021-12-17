import main
import unittest

suite "Day 17":
  test "part1":
    let target = "test1".parseTarget
    check target.part1 == 45

  test "part2":
    let target = "test1".parseTarget
    check target.part2 == 112
