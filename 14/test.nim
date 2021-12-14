import main
import math
import sequtils
import tables
import unittest

suite "day 11":
  test "stepCounts1":
    let (pt, inserts) = "test1".parseInput
    check pt.stepCounts(inserts, 1) == "NCNBCHB".toCountTable

  test "stepCounts2":
    let (pt, inserts) = "test1".parseInput
    check pt.stepCounts(inserts, 2) == "NBCCNBBBCBHCB".toCountTable

  test "stepCounts3":
    let (pt, inserts) = "test1".parseInput
    check pt.stepCounts(inserts, 3) == "NBBBCNCCNBBNBNBBCHBHHBCHB".toCountTable

  test "stepCounts4":
    let (pt, inserts) = "test1".parseInput
    check pt.stepCounts(inserts, 4) == "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB".toCountTable

  test "stepCounts5":
    let (pt, inserts) = "test1".parseInput
    check pt.stepCounts(inserts, 5).values.toSeq.sum == 97

  test "stepCounts10":
    let (pt, inserts) = "test1".parseInput
    check pt.stepCounts(inserts, 10).values.toSeq.sum == 3073

  test "part1":
    let (pt, inserts) = "test1".parseInput
    check pt.steps(inserts, 10) == 1588

  test "part2":
    let (pt, inserts) = "test1".parseInput
    check pt.steps(inserts, 40) == 2188189693529
