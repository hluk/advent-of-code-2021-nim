import main
import sequtils
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

  test "repeated":
    let map = "test1".parseMap.toRepeated(5)
    check map.height == 50
    check map.width == 50
    check toSeq(10..<20).mapIt(map[(it,0)]).join == "2274862853"
    check toSeq(0..<10).mapIt(map[(it,10)]).join == "2274862853"
    check toSeq(10..<20).mapIt(map[(it,10)]).join == "3385973964"

  test "part2":
    let map = "test1".parseMap
    check map.lowest(5) == 315
