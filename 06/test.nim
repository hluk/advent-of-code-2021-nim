import main
import unittest

suite "day 6":
  test "run":
    let timers = parseTimers("test1")
    check timers.run(0) == 5
    check timers.run(1) == 5
    check timers.run(2) == 6
    check timers.run(3) == 7
    check timers.run(4) == 9
    check timers.run(5) == 10
    check timers.run(6) == 10
    check timers.run(7) == 10
    check timers.run(8) == 10
    check timers.run(9) == 11
    check timers.run(18) == 26
    check timers.run(80) == 5934
    check timers.run(256) == 26984457539
