import main
import strutils
import unittest

suite "day 11":
  test "foldY":
    var (dots, folds) = "test1".parseInput
    check dots.foldDots(folds[0..0]) == 17

  test "foldYX":
    var (dots, folds) = "test1".parseInput
    check dots.foldDots(folds[0..1]) == 16

  test "foldAll":
    var (dots, folds) = "test1".parseInput
    discard dots.foldDots(folds)
    let expected = dedent """
      #####..................................
      #...#..................................
      #...#..................................
      #...#..................................
      #####..................................
      ......................................."""
    check $dots == expected
