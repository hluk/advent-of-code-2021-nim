import heapqueue
import sequtils
import strutils
import tables

type
  Reg* = enum W, X, Y, Z
  Alu* = array[W..Z, int64]
  RegOrInt = object
    r: Reg
    i: int64
    isReg: bool
  Ins = enum Inp, Add, Mul, Div, Mod, Eql
  Instruction = tuple
    ins: Ins
    a: Reg
    b: RegOrInt
  Program* = seq[Instruction]
  Cache* = Table[seq[int], (Alu, int)]
  Input = seq[int]
  State1 = object
    z: int64
    input: Input
  State2 = object
    z: int64
    input: Input

const NoArg = RegOrInt()

proc `[]`*(alu: Alu, r: RegOrInt): int64 =
  if r.isReg:
    alu[r.r]
  else:
    r.i

proc toReg*(a: string): Reg =
  case a
  of "w": W
  of "x": X
  of "y": Y
  of "z": Z
  else:
    raise newException(ValueError, "Unknown register: " & a)

proc toRegOrInt*(a: string): RegOrInt =
  if a[0].isDigit or a[0] == '-':
    result.i = a.parseInt
  else:
    result.isReg = true
    result.r = a.toReg

proc parseProgramLine*(line: string): Instruction =
  var x = line.split(' ')
  case x[0]
  of "inp": (Inp, x[1].toReg, NoArg)
  of "add": (Add, x[1].toReg, x[2].toRegOrInt)
  of "mul": (Mul, x[1].toReg, x[2].toRegOrInt)
  of "div": (Div, x[1].toReg, x[2].toRegOrInt)
  of "mod": (Mod, x[1].toReg, x[2].toRegOrInt)
  of "eql": (Eql, x[1].toReg, x[2].toRegOrInt)
  else:
    raise newException(ValueError, "Unknown instruction: " & x[0])

proc parseProgram*(filename: string): Program =
  filename.lines.toSeq.map(parseProgramLine)

proc run*(alu: var Alu, ins: Ins, a: Reg, b: RegOrInt, inp: var int, input: varargs[int]): void =
  case ins
  of Inp:
    alu[a] = input[inp]
    inc inp
  of Add: alu[a] += alu[b]
  of Mul: alu[a] *= alu[b]
  of Div: alu[a] = alu[a] div alu[b]
  of Mod: alu[a] = alu[a] mod alu[b]
  of Eql: alu[a] = (alu[a] == alu[b]).int

proc run*(prg: Program, cache: var Cache, input: varargs[int]): Alu =
  var inp = 0
  var start = 0

  for i in countdown(input.len-1, 0):
    let key = input[0..i]
    if key in cache:
      result = cache[key][0]
      start = cache[key][1]
      inp = i+1
      if start == prg.len:
        return
      break

  for i, (ins, a, b) in prg[start..^1]:
    if i != start and ins == Inp:
      let key = input[0..<inp]
      cache[key] = (result, i+start)
    result.run(ins, a, b, inp, input)

  cache[input[0..^1]] = (result, prg.len)

proc run*(prg: Program, input: varargs[int]): Alu =
  var cache: Cache
  prg.run(cache, input)

proc `<`(x, y: State1): bool =
  let a = x.input
  let b = y.input
  x.z < y.z or (
    x.z == y.z and
    (a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11],a[12],a[13]) >
    (b[0],b[1],b[2],b[3],b[4],b[5],b[6],b[7],b[8],b[9],b[10],b[11],b[12],b[13])
  )

proc `<`(x, y: State2): bool =
  let a = x.input
  let b = y.input
  x.z < y.z or (
    x.z == y.z and
    (a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11],a[12],a[13]) <
    (b[0],b[1],b[2],b[3],b[4],b[5],b[6],b[7],b[8],b[9],b[10],b[11],b[12],b[13])
  )

template findInput(prg: Program, q: untyped): untyped =
  var cache: Cache

  while q.len != 0:
    var s = q.pop
    var x = s.input
    if s.z == 0:
      return x.join.parseInt

    for i in 0..<x.len:
      let y = x[i]
      for n in 1..9:
        x[i] = n
        if x notin cache:
          s.z = prg.run(cache, x)[Z]
          s.input = x
          q.push(s)
      x[i] = y

  return -1

proc part1*(prg: Program): int =
  var q: HeapQueue[State1]
  q.push(State1(z: -1i64, input: @[9,9,9,9,9,9,9,9,9,9,9,9,9,9]))
  prg.findInput(q)

proc part2*(prg: Program): int =
  var q: HeapQueue[State2]
  q.push(State2(z: -1i64, input: @[1,1,1,1,1,1,1,1,1,1,1,1,1,1]))
  prg.findInput(q)

if isMainModule:
  let prg = "input".parseProgram
  let p1 = prg.part1
  echo "Part1: ", p1
  let p2 = prg.part2
  echo "Part2: ", p2
  assert p1 == 92967699949891
  assert p2 == 91411143612181
