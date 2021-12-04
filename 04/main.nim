import sequtils
import strutils

const size = 5

let lines = stdin.lines.toSeq

let drawn = lines[0].split(",").map(parseInt)

let players = countup(2, lines.len - 1, size + 1).toSeq.mapIt(
  lines[it ..< it + size]
  .mapIt(it.splitWhitespace.map(parseInt))
)

proc findWinningRound(player: seq[seq[int]]): int =
  var markedRows: array[0..size, uint8]
  var markedCols: array[0..size, uint8]
  for round, n in drawn:
    for r, row in player:
      for c, guess in row:
        if guess == n:
          markedRows[r] += 1
          markedCols[c] += 1
          if markedRows[r] == size or markedCols[c] == size:
            return round
  return drawn.len

let winningRounds = players.map(findWinningRound)

template winningResultFor(winnigOp: untyped): int =
  let winningPlayer = winnigOp(winningRounds)
  let winningRound = winningRounds[winningPlayer]
  var result = 0
  for row in players[winningPlayer]:
    for guess in row:
      if not drawn[0..winningRound].contains(guess):
        result += guess
  result * drawn[winningRound]

echo "Part1: ", winningResultFor(minIndex)
echo "Part2: ", winningResultFor(maxIndex)
