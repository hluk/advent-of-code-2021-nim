import main
import strutils
import unittest

suite "Day 15":
  test "part0":
    let map = "test0".parseMap
    check map.lowest == 9

  test "part01":
    let map = "test01".parseMap
    check map.lowest == 12

  test "part1":
    let map = "test1".parseMap
    check map.lowest == 40

  test "enlarge":
    let map = "test1".parseMap
    let map5 = map.enlarge 
    check map5.len == map.len * 5
    check map5[0].len == map[0].len * 5
    check map5[0][10..<20].join == "2274862853"

  test "part2":
    let map = "test1".parseMap
    check map.lowest2 == 315
