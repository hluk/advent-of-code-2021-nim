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
  State = object
    steps: int
    pods: Pods
    hall: Hall

const
  A* = 1u16
  B* = 10u16
  C* = 100u16
  D* = 1000u16
  STEPS = [[
      @[(1,2),(0,3)],
      @[(2,2),(1,4),(0,5)],
      @[(3,2),(2,4),(1,6),(0,7)],
      @[(4,2),(3,4),(2,6),(1,8),(0,9)],
    ], [
      @[(2,2),(3,4),(4,6),(5,8),(6,9)],
      @[(3,2),(4,4),(5,6),(6,7)],
      @[(4,2),(5,4),(6,5)],
      @[(5,2),(6,3)],
  ]]

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

proc moveFromHall(s: var State): void =
  for i, expected in [A, B, C, D]:
    let j = s.pods[i].moveFromHallIndex(expected)
    if j == -1:
      continue

    for steps_lr in STEPS:
      for (k,steps) in steps_lr[i]:
        let h = s.hall[k]
        if h == expected:
          s.steps = s.steps + h.int * (j + steps)
          s.pods = s.pods.with(i, j, h)
          s.hall = s.hall.with(k, 0)
          s.moveFromHall
          return
        if h != 0: break

iterator moveToHall(s: State): State =
  for i, expected in [A, B, C, D]:
    let j = s.pods[i].moveToHallIndex(expected)
    if j == -1:
      continue

    var v = s.pods[i][j]
    for steps_lr in STEPS:
      for (k,steps) in steps_lr[i]:
        if s.hall[k] != 0: break
        var state = State(
          steps: s.steps + v.int * (j + steps),
          pods: s.pods.with(i, j, 0),
          hall: s.hall.with(k, v),
        )
        state.moveFromHall
        yield state

proc isFinished(s: State): bool =
  s.pods[0].allIt(it == A) and
  s.pods[1].allIt(it == B) and
  s.pods[2].allIt(it == C) and
  s.pods[3].allIt(it == D)

proc solve*(pods: Pods): int =
  var q: HeapQueue[State]
  q.push(State(pods: pods))

  var visited: HashSet[(Pods, Hall)]

  while q.len != 0:
    let s = q.pop

    if visited.containsOrIncl (s.pods, s.hall):
      continue

    if s.isFinished:
      return s.steps

    for state in s.moveToHall:
      q.push(state)

proc unfolded*(p: Pods): Pods =
  [
    @[p[0][0],D,D,p[0][1]],
    @[p[1][0],C,B,p[1][1]],
    @[p[2][0],B,A,p[2][1]],
    @[p[3][0],A,C,p[3][1]]
  ]

proc part1*(pods: Pods): int =
  pods.solve

proc part2*(pods: Pods): int =
  pods.unfolded.solve

if isMainModule:
  let pods = "input".parsePods
  echo "Part1: ", pods.part1
  echo "Part2: ", pods.part2
