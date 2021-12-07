import main
import unittest

suite "day 6":
  test "align":
    let crabs = parseCrabs("test1")
    check crabs.align(1) == 41
    check crabs.align(2) == 37
    check crabs.align(3) == 39
    check crabs.align(10) == 71

  test "minFuelAlign":
    let crabs = parseCrabs("test1")
    check crabs.minFuelAlign == 37

  test "sumUpTo":
    check sumUpTo(1) == 1
    check sumUpTo(2) == 3
    check sumUpTo(4) == 10
    check sumUpTo(11) == 66

  test "align2":
    let crabs = parseCrabs("test1")
    check crabs.align2(2) == 206
    check crabs.align2(5) == 168

  test "minFuelAlign":
    let crabs = parseCrabs("test1")
    check crabs.minFuelAlign2 == 168
