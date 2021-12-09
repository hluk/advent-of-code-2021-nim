import main
import unittest

suite "day 9":
  test "riskLevel":
    let hm = "test1".parseHeightMap
    check hm.riskLevel == 15

  test "largestBasins":
    var hm = "test1".parseHeightMap
    check hm.largestBasins == 1134
