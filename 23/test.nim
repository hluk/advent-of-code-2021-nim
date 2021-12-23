import main
import unittest

suite "Day 22":
  test "parsePods":
    let pods = "test1".parsePods
    check pods == [@[B,A], @[C,D], @[B,C], @[D,A]]

  test "unfolded":
    let pods = "test1".parsePods
    check pods.unfolded == [@[B,D,D,A], @[C,C,B,D], @[B,B,A,C], @[D,A,C,A]]

  test "part1":
    let pods = "test1".parsePods
    check pods.part1 == 12521

  test "part2":
    let pods = "test1".parsePods
    check pods.part2 == 44169
