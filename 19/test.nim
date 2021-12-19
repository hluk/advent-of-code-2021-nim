import main
import unittest

suite "Day 19":
  test "solution":
    let scanners = "test1".parseScanners
    let s = scanners.solution
    check s[0] == 79
    check s[1] == 3621
