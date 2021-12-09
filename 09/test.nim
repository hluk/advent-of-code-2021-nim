import main
import unittest

suite "day 9":
  test "lowPositions":
    let hm = "test1".parseHeightMap
    check hm.lowPositions == [(0,1), (0,9), (2,2), (4,6)]

  test "riskLevel":
    let hm = "test1".parseHeightMap
    check riskLevel(hm, hm.lowPositions) == 15

  test "largestBasins":
    var hm = "test1".parseHeightMap
    check hm.largestBasins == 1134
