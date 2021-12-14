import sequtils
import strscans
import strutils
import tables

type PolymerTemplate = string
type Key = tuple[a, b: char]
type Insertions = Table[Key, char]
type Counts = CountTable[char]
type Cache = Table[(Key, int), Counts]

proc parseInsertion(line: string): (Key, char) =
  let (ok, a, b, elem) = line.scanTuple("$c$c -> $c")
  assert ok
  ((a, b), elem)

proc parseInsertions(lines: string): Insertions =
  lines.splitLines.map(parseInsertion).toTable

proc parseInput*(filename: string): (PolymerTemplate, Insertions) =
  let lines = filename.readFile.strip.split("\n\n", 1)
  (lines[0], lines[1].parseInsertions)

proc steps(k: Key, inserts: Insertions, cache: var Cache, steps: int): Counts =
  if steps == 0: return

  let cacheKey = (k, steps)
  result = cache.getOrDefault(cacheKey)
  if result.len == 0:
    let insert = inserts[k]
    result.inc(insert)
    result.merge(steps((k.a, insert), inserts, cache, steps - 1))
    result.merge(steps((insert, k.b), inserts, cache, steps - 1))
    cache[cacheKey] = result

proc stepCounts*(pt: PolymerTemplate, inserts: Insertions, steps: int): Counts =
  result = pt.toCountTable
  var cache: Cache
  for i in 0..<pt.len-1:
    result.merge(steps((pt[i], pt[i+1]), inserts, cache, steps))

proc steps*(pt: PolymerTemplate, inserts: Insertions, steps: int): int =
  let counts = pt.stepCounts(inserts, steps)
  counts.largest.val - counts.smallest.val

if isMainModule:
  let (pt, inserts) = "input".parseInput
  echo "Part1: ", pt.steps(inserts, 10)
  echo "Part2: ", pt.steps(inserts, 40)
