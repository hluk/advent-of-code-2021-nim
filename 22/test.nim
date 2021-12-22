import main
import unittest

suite "Day 21":
  test "part1":
    let ops = "test2".parseInput
    check ops.part1 == 590784

  test "part2.0":
    var ops: OpRanges = @[
      (true, ((10,12),(10,12),(10,12))),
    ]
    check ops.part2 == 27

    ops.add (true, ((11,13),(11,13),(11,13)))
    check ops.part2 == 27+19

    ops.add (false, ((9,11),(9,11),(9,11)))
    check ops.part2 == 27+19-8
    ops.add (false, ((9,11),(9,11),(9,11)))
    check ops.part2 == 27+19-8

    ops.add (true, ((10,10),(10,10),(10,10)))
    check ops.part2 == 27+19-8+1
    ops.add (true, ((10,10),(10,10),(10,10)))
    check ops.part2 == 27+19-8+1

  test "part2.1":
    let ops = "test1".parseInput
    check ops.part2 == 39

  test "part2.2":
    let ops = "test3".parseInput
    check ops.part2 == 2758514936282235
