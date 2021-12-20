import main
import unittest

suite "Day 20":
  test "solution":
    var (alg, img) = "test1".parseInput
    alg.apply(img, 2)
    check img.whiteCount == 35
    alg.apply(img, 50-2)
    check img.whiteCount == 3351
