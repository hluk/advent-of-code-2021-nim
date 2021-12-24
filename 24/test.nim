import main
import unittest

suite "Day 22":
  test "run1":
    let prg = "test1".parseProgram
    check prg.run(9)[X] == -9
    check prg.run(-9)[X] == 9
    check prg.run(0)[X] == 0

  test "run2":
    let prg = "test2".parseProgram
    check prg.run(1, 3)[Z] == 1
    check prg.run(3, 1)[Z] == 0
    check prg.run(0, 3)[Z] == 0

  test "run3":
    let prg = "test3".parseProgram
    check prg.run(0) == @[0i64,0i64,0i64,0i64]
    check prg.run(1) == @[0i64,0i64,0i64,1i64]
    check prg.run(2) == @[0i64,0i64,1i64,0i64]
    check prg.run(3) == @[0i64,0i64,1i64,1i64]
    check prg.run(4) == @[0i64,1i64,0i64,0i64]
    check prg.run(5) == @[0i64,1i64,0i64,1i64]
    check prg.run(6) == @[0i64,1i64,1i64,0i64]
    check prg.run(7) == @[0i64,1i64,1i64,1i64]
    check prg.run(8) == @[1i64,0i64,0i64,0i64]
    check prg.run(15) == @[1i64,1i64,1i64,1i64]

  test "cache2":
    let prg = "test2".parseProgram
    var cache: Cache
    check prg.run(cache, 3, 1)[Z] == 0
    check prg.run(cache, 3, 1)[Z] == 0
    check prg.run(cache, 1, 3)[Z] == 1
    check prg.run(cache, 1, 3)[Z] == 1
    check prg.run(cache, 1, 0)[Z] == 0
    check prg.run(cache, 1, 0)[Z] == 0
    check prg.run(cache, 1, 1)[Z] == 0
    check prg.run(cache, 1, 1)[Z] == 0

  test "cache3":
    let prg = "test3".parseProgram
    var cache: Cache
    check prg.run(cache, 15) == @[1i64,1i64,1i64,1i64]
    check prg.run(cache, 15) == @[1i64,1i64,1i64,1i64]
