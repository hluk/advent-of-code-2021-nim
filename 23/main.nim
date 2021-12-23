import heapqueue
import math
import sequtils
import sets
import strscans
import strutils
import sugar

type
  Home = seq[uint16]
  Pods = array[4, Home]
  Hall = array[7, uint16]
  State = tuple
    steps: int
    pods: Pods
    hall: Hall

const
  EMPTY* = 0u16
  A* = 1u16
  B* = 10u16
  C* = 100u16
  D* = 1000u16
  FINAL: Pods = [@[A, A], @[B, B], @[C, C], @[D, D]]
  FINAL2: Pods = [@[A, A, A, A], @[B, B, B, B], @[C, C, C, C], @[D, D, D, D]]
  STEPS = [
    (
      @[(1,2),(0,3)],
      @[(2,2),(3,4),(4,6),(5,8),(6,9)],
    ),
    (
      @[(2,2),(1,4),(0,5)],
      @[(3,2),(4,4),(5,6),(6,7)],
    ),
    (
      @[(3,2),(2,4),(1,6),(0,7)],
      @[(4,2),(5,4),(6,5)],
    ),
    (
      @[(4,2),(3,4),(2,6),(1,8),(0,9)],
      @[(5,2),(6,3)],
    )
  ]

proc `<`(x, y: State): bool =
  x.steps < y.steps

proc v(c: char): uint16 =
  10u16^(c.ord - 'A'.ord)

proc c(v: uint16): char =
  case v
  of 1: 'A'
  of 10: 'B'
  of 100: 'C'
  of 1000: 'D'
  else: '.'

proc parsePods*(filename: string): Pods =
  let lines = filename.readLines(4)[2..3]
  let (ok1, a1, b1, c1, d1) = lines[0].scanTuple("###$c#$c#$c#$c###")
  assert ok1
  let (ok2, a2, b2, c2, d2) = lines[1].scanTuple("  #$c#$c#$c#$c#")
  assert ok2
  [@[a1.v,a2.v],@[b1.v,b2.v],@[c1.v,c2.v],@[d1.v,d2.v]]

proc with(pods: Pods, i, j: int, v: uint16): Pods =
  result = pods
  result[i][j] = v

proc with(hall: Hall, k: int, v: uint16): Hall =
  result = hall
  result[k] = v

proc render(s: State): string =
  let depth = s.pods[0].len
  $s.steps & "\n" &
  s.hall[0].c & s.hall[1].c &
  "." & s.hall[2].c &
  "." & s.hall[3].c &
  "." & s.hall[4].c &
  "." & s.hall[5].c & s.hall[6].c & "\n" &
  toSeq(0..<depth).map(
    j => "  " & toSeq(0..3).map(
      i => s.pods[i][j].c
    ).join("#")
  ).join("\n")

proc moveToHallIndex(home: Home, expected: uint16): int =
  for i, v in home:
    if v == 0:
      continue

    # Already in place?
    if home[i..<home.len].allIt(it == expected):
      break

    return i

  return -1

proc moveFromHallIndex(home: Home, expected: uint16): int =
  for i in countdown(home.len-1, 0):
    let v = home[i]
    if v == 0:
      return i

    if v == expected:
      continue

    break

  return -1

proc moveFromHall(s: State): State =
  for i, expected in [A, B, C, D]:
    let j = s.pods[i].moveFromHallIndex(expected)
    if j == -1:
      continue

    for (k,steps) in STEPS[i][0]:
      let h = s.hall[k]
      if h == expected:
        return moveFromHall (
          steps: s.steps + h.int * (j + steps),
          pods: s.pods.with(i, j, h),
          hall: s.hall.with(k, 0)
        )
      if h != 0: break

    for (k,steps) in STEPS[i][1]:
      let h = s.hall[k]
      if h == expected:
        return moveFromHall (
          steps: s.steps + h.int * (j + steps),
          pods: s.pods.with(i, j, h),
          hall: s.hall.with(k, 0)
        )
      if h != 0: break
  s

proc solve*(pods: Pods, final: Pods): int =
  var q: HeapQueue[State]
  q.push((0, pods, [EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY]))

  var visited: HashSet[(Pods, Hall)]

  while q.len != 0:
    let s = q.pop
    assert s.steps <= 44169

    if visited.containsOrIncl (s.pods, s.hall):
      continue

    if s.pods == final:
      return s.steps

    for i, expected in [A, B, C, D]:
      let j = s.pods[i].moveToHallIndex(expected)
      if j == -1:
        assert s.pods[i].allIt(it == 0 or it == expected)
        continue

      var v = s.pods[i][j]
      assert v != 0
      for (k,steps) in STEPS[i][0]:
        if s.hall[k] != 0: break
        let state = moveFromHall (
          steps: s.steps + v.int * (j + steps),
          pods: s.pods.with(i, j, 0),
          hall: s.hall.with(k, v),
        )
        q.push(state)
      for (k,steps) in STEPS[i][1]:
        if s.hall[k] != 0: break
        let state = moveFromHall (
          steps: s.steps + v.int * (j + steps),
          pods: s.pods.with(i, j, 0),
          hall: s.hall.with(k, v),
        )
        q.push(state)

proc unfolded*(p: Pods): Pods =
  [
    @[p[0][0],D,D,p[0][1]],
    @[p[1][0],C,B,p[1][1]],
    @[p[2][0],B,A,p[2][1]],
    @[p[3][0],A,C,p[3][1]]
  ]

proc part1*(pods: Pods): int =
  pods.solve(FINAL)

proc part2*(pods: Pods): int =
  pods.unfolded.solve(FINAL2)

if isMainModule:
  let pods = "input".parsePods
  echo "Part1: ", pods.part1
  echo "Part2: ", pods.part2
