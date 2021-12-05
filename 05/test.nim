import main
import unittest

suite "day 5":
  test "part1":
    let vents = onlyNondiagonal(parseVents("test1"))
    check countOverlaps(vents) == 5

  test "part2":
    let vents = parseVents("test1")
    check countOverlaps(vents) == 12
