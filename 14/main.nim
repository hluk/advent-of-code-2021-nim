import algorithm
import sequtils
import strscans
import strutils
import tables

type PolymerTemplate = string
type Insertions = Table[(char, char), char]
type Counts = CountTable[char]

proc parseInsertion(line: string): ((char, char), char) =
  let (ok, a, b, elem) = line.scanTuple("$c$c -> $c")
  assert ok
  ((a, b), elem)

proc parseInsertions(lines: string): Insertions =
  lines.splitLines.map(parseInsertion).toTable

proc parseInput*(filename: string): (PolymerTemplate, Insertions) =
  let lines = filename.readFile.strip.split("\n\n", 1)
  (lines[0], lines[1].parseInsertions)

type Cache = Table[(char, char, int), Counts]

proc steps(a: char, b: char, inserts: Insertions, cache: var Cache, steps: int): Counts =
  if steps == 0: return

  let cacheKey = (a, b, steps)
  result = cache.getOrDefault(cacheKey)
  if result.len == 0:
    let insert = inserts[(a, b)]
    result.inc(insert)
    let c1 = steps(a, insert, inserts, cache, steps - 1)
    let c2 = steps(insert, b, inserts, cache, steps - 1)
    for (k, v) in c1.pairs:
      result.inc(k, v)
    for (k, v) in c2.pairs:
      result.inc(k, v)
    cache[cacheKey] = result

proc stepCounts*(pt: PolymerTemplate, inserts: Insertions, steps: int): Counts =
  result = pt.toCountTable
  var cache: Cache
  for i in 0..<pt.len-1:
    let c1 = steps(pt[i], pt[i+1], inserts, cache, steps)
    for (k, v) in c1.pairs:
      result.inc(k, v)

proc steps*(pt: PolymerTemplate, inserts: Insertions, steps: int): int =
  var counts = pt.stepCounts(inserts, steps)
  counts.sort
  let c = counts.values.toSeq
  c[0] - c[^1]

if isMainModule:
  let (pt, inserts) = "input".parseInput
  echo "Part1: ", pt.steps(inserts, 10)
  echo "Part2: ", pt.steps(inserts, 40)
