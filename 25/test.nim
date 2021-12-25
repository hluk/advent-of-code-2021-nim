import main
import unittest

suite "Day 25":
  test "part1":
    let map = "test1".parseMap
    check map.part1 == 58
