import main
import math
import unittest

suite "Day 18":
  test "parseNum1":
    let n = "[[[[[9,8],1],2],3],4]".parseNum
    check $n == "[[[[[9,8],1],2],3],4]"

  test "parseNum2":
    let n = "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]".parseNum
    check $n == "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"

  test "explode1":
    var n = "[[[[[9,8],1],2],3],4]".parseNum
    n.reduce
    check $n == "[[[[0,9],2],3],4]"

  test "explode2":
    var n = "[7,[6,[5,[4,[3,2]]]]]".parseNum
    n.reduce
    check $n == "[7,[6,[5,[7,0]]]]"

  test "explode3":
    var n = "[[6,[5,[4,[3,2]]]],1]".parseNum
    n.reduce
    check $n == "[[6,[5,[7,0]]],3]"

  test "explode4":
    var n = "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]".parseNum
    n.reduce
    check $n == "[[3,[2,[8,0]]],[9,[5,[7,0]]]]"

  test "split1":
    var n = @[Node(nest: 1, x: 10), Node(x: 1)]
    check $n == "[10,1]"
    n.reduce
    check $n == "[[5,5],1]"

  test "split1":
    var n = @[Node(nest: 1, x: 11), Node(x: 1)]
    check $n == "[11,1]"
    n.reduce
    check $n == "[[5,6],1]"

  test "add1":
    let a = "[[1,2]]".parseNum
    let b = "[3,4]".parseNum
    check $(a + b) == "[[[1,2]],[3,4]]"

  test "add2":
    let a = "[[[[4,3],4],4],[7,[[8,4],9]]]".parseNum
    let b = "[1,1]".parseNum
    check $(a + b) == "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"

  test "add3":
    let a = "[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]".parseNum
    let b = "[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]".parseNum
    check $(a + b) == "[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]"

  test "add4":
    let a = "[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]".parseNum
    let b = "[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]".parseNum
    check $(a + b) == "[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]"

  test "add5":
    let a = "[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]".parseNum
    let b = "[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]".parseNum
    check $(a + b) == "[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]"

  test "add6":
    let a = "[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]".parseNum
    let b = "[7,[5,[[3,8],[1,4]]]]".parseNum
    check $(a + b) == "[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]"

  test "add7":
    let a = "[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]".parseNum
    let b = "[[2,[2,2]],[8,[8,1]]]".parseNum
    check $(a + b) == "[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]"

  test "add8":
    let a = "[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]".parseNum
    let b = "[2,9]".parseNum
    check $(a + b) == "[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]"

  test "add9":
    let a = "[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]".parseNum
    let b = "[1,[[[9,3],9],[[9,0],[0,7]]]]".parseNum
    check $(a + b) == "[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]"

  test "add10":
    let a = "[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]".parseNum
    let b = "[[[5,[7,4]],7],1]".parseNum
    check $(a + b) == "[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]"

  test "add11":
    let a = "[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]".parseNum
    let b = "[[[[4,2],2],6],[8,7]]".parseNum
    check $(a + b) == "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"

  test "magnitude1":
    let num = "[9,1]".parseNum
    check num.magnitude == 29

  test "magnitude2":
    let num = "[[9,1],[1,9]]".parseNum
    check num.magnitude == 129

  test "magnitude3":
    let num = "[[1,2],[[3,4],5]]".parseNum
    check num.magnitude == 143

  test "magnitude4":
    let num = "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]".parseNum
    check num.magnitude == 1384

  test "magnitude5":
    let num = "[[[[1,1],[2,2]],[3,3]],[4,4]]".parseNum
    check num.magnitude == 445

  test "magnitude6":
    let num = "[[[[3,0],[5,3]],[4,4]],[5,5]]".parseNum
    check num.magnitude == 791

  test "magnitude7":
    let num = "[[[[5,0],[7,4]],[5,5]],[6,6]]".parseNum
    check num.magnitude == 1137

  test "magnitude8":
    let num = "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]".parseNum
    check num.magnitude == 3488

  test "magnitude9":
    let num = "[[[6,[6,6]]]]".parseNum
    check num.magnitude == 3*3*3*6 + 3*3*2*3*6 + 3*3*2*2*6

  test "sum01":
    let nums = "test01".parseNums
    check $nums.sum == "[[[[1,1],[2,2]],[3,3]],[4,4]]"

  test "sum02":
    let nums = "test02".parseNums
    check $nums.sum == "[[[[3,0],[5,3]],[4,4]],[5,5]]"

  test "sum03":
    let nums = "test03".parseNums
    check $nums.sum == "[[[[5,0],[7,4]],[5,5]],[6,6]]"

  test "sum1":
    let nums = "test1".parseNums
    check $nums.sum == "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"

  test "sum2":
    let nums = "test2".parseNums
    check $nums.sum == "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]"

  test "part1":
    let nums = "test2".parseNums
    check nums.part1 == 4140

  test "part2":
    let nums = "test2".parseNums
    check nums.part2 == 3993
