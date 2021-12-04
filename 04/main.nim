import math
import sequtils
import sets
import strutils
import sugar

const size = 5

let lines = stdin.lines.toSeq

let drawn = lines[0].split(",").map(parseInt)

let players = countup(2, lines.len - 1, size + 1).toSeq.mapIt(
  lines[it ..< it + size]
  .mapIt(it.splitWhitespace.map(parseInt))
)

template transposed(a: untyped): untyped =
  toSeq(0..<a[0].len).map(
    (row) => toSeq(0..<a.len).map(
      (col) => player[col][row]
    )
  )

proc findWinningRoundForRows(player: seq[seq[int]]): int =
  player
  .mapIt(it.mapIt(drawn.find(it)))
  .filterIt(not it.contains(-1))
  .mapIt(it.max)
  .min

proc findWinningRound(player: seq[seq[int]]): int =
  min(
    findWinningRoundForRows(player),
    findWinningRoundForRows(player.transposed))

let winningRounds = players.map(findWinningRound)

template winningResultFor(winnigOp: untyped): int =
  let winningPlayer = winnigOp(winningRounds)
  let winningRound = winningRounds[winningPlayer]
  let drawnSet = drawn[0..winningRound].toHashSet
  let result = players[winningPlayer].foldl(
    a + b.filterIt(it notin drawnSet).sum, 0)
  result * drawn[winningRound]

echo "Part1: ", winningResultFor(minIndex)
echo "Part2: ", winningResultFor(maxIndex)
