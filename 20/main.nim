import sequtils
import sets
import strutils

type
  Pos = (int, int)
  Alg = string
  Img = object
    data: HashSet[Pos]
    minX,maxX,minY,maxY: int

proc setWhite*(img: var Img, x, y: int): void =
  img.data.incl((x, y))
  img.minX = min(x, img.minX)
  img.maxX = max(x, img.maxX)
  img.minY = min(y, img.minY)
  img.maxY = max(y, img.maxY)

proc whiteCount*(img: Img): int =
  img.data.len

proc `$`*(img: Img): string =
  for y in img.minY..img.maxY:
    for x in img.minX..img.maxX:
      if (x, y) in img.data:
        result &= '#'
      else:
        result &= '.'
    result &= '\n'

proc parseImage*(lines: string): Img =
  for y, line in lines.strip.splitLines.toSeq:
    for x, c in line:
      if c == '#':
        result.setWhite(x, y)

proc parseInput*(filename: string): (Alg, Img) =
  let parts = filename.readFile.split("\n\n")
  (parts[0].strip, parts[1].parseImage)

proc readNumberAt*(img: Img, xc, yc: int, whiteOutside: bool): int =
  for y in yc-1..yc+1:
    for x in xc-1..xc+1:
      if whiteOutside and (y < img.minY or y > img.maxY or x < img.minX or x > img.maxX):
        result = (result shl 1) or 1
      else:
        result = (result shl 1) or ((x, y) in img.data).ord

proc apply*(alg: Alg, img: var Img, repeat: int): void =
  var img2: Img
  for r in 0..<repeat:
    let whiteOutside = alg[0] == '#' and r mod 2 == 1
    for y in img.minY-1..img.maxY+1:
      for x in img.minX-1..img.maxX+1:
        let n = img.readNumberAt(x, y, whiteOutside)
        if alg[n] == '#':
          img2.setWhite(x, y)
    (img, img2) = (img2, Img())

if isMainModule:
  var (alg, img) = "input".parseInput
  alg.apply(img, 2)
  echo "Part1: ", img.whiteCount
  alg.apply(img, 50-2)
  echo "Part2: ", img.whiteCount
