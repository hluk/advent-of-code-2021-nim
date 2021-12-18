import math
import sequtils
import strutils

type
  Node* = object
    nest*: int
    unnest*: int
    x*: int
  Num* = seq[Node]
  Nums* = seq[Num]

proc `$`*(num: Num): string =
  var nest = 0
  assert num.len >= 2
  for n in num:
    nest += n.nest - n.unnest
    assert nest > 0

    if n.unnest != 0:
      result &= ']'.repeat(n.unnest)
    if result.len > 0 or n.unnest != 0:
      result &= ','
    if n.nest != 0:
      result &= '['.repeat(n.nest)

    result &= $n.x

  result &= ']'.repeat(nest)

proc reduce*(num: var Num): void =
  var changed = true
  while changed:
    changed = false

    var nest = 0
    var i = 0
    while i < num.len:
      let n = num[i]
      let nest2 = nest + n.nest - n.unnest
      if nest2 > 4 and num[i + 1].nest == 0:
        if i > 0:
          num[i - 1].x += n.x
        if i + 2 < num.len:
          num[i + 2].x += num[i + 1].x
          dec num[i + 2].unnest
          assert num[i + 2].unnest >= 0

        num[i].x = 0
        dec num[i].nest
        assert num[i].nest >= 0

        num.delete(i+1)
        changed = true
      else:
        nest = nest2
        inc i

    for i in 0..<num.len:
      let x = num[i].x
      if x >= 10:
        num[i].x = x div 2
        inc num[i].nest
        num.insert(Node(x: (x / 2).ceil.int), i+1)
        if i + 2 < num.len:
          inc num[i + 2].unnest
        changed = true
        break

proc magnitude*(num: Num): int =
  var d = ""
  for i, n in num:
    if n.unnest > 0:
      d[^n.unnest..^1] = ""
    if d.endsWith('l'):
      d[^1] = 'r'
    if n.nest > 0:
      d &= 'l'.repeat(n.nest)

    let l = d.count('l')
    let r = d.count('r')
    result += 3^l * 2^r * n.x

proc nestEnd(num: Num): int =
  num.foldl(a + b.nest - b.unnest, 0)

proc `+`*(x, y: Num): Num =
  result = x & y
  inc result[0].nest
  result[x.len].unnest = x.nestEnd
  result.reduce

proc parseNum*(numString: string): Num =
  var nest = 0
  var unnest = 0
  for c in numString:
    if c == '[': inc nest
    elif c == ']': inc unnest
    elif c != ',':
      result.add(Node(nest: nest, unnest: unnest, x: c.ord - '0'.ord))
      nest = 0
      unnest = 0

proc parseNums*(filename: string): Nums =
  filename.lines.toSeq.map(parseNum)

proc sum*(nums: Nums): Num =
  nums[1..^1].foldl(a + b, nums[0])

proc part1*(nums: Nums): int =
  nums.sum.magnitude

proc part2*(nums: Nums): int =
  for i in 0..<nums.len:
    for j in i+1..<nums.len:
      result = max(result, magnitude(nums[i] + nums[j]))
      result = max(result, magnitude(nums[j] + nums[i]))

if isMainModule:
  let nums = "input".parseNums
  echo "Part1: ", nums.part1
  echo "Part2: ", nums.part2
