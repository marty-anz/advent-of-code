#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def part1(input)
  jolts = input.map(&:to_i).sort

  jolts << jolts[-1] + 3

  counts = { 1 =>0, 2 => 0, 3 => 0 }

  p = 0

  while !jolts.empty?
    jolt = jolts.shift
    counts[jolt - p] += 1
    p = jolt
  end

  counts[1] * counts[3]
end

ans = part1(aoc.test_data)

aoc.run(1, 220, ans) { |data| part1(data) }

def arrangements(jolt, chargers, seen)
  return seen[jolt] if !seen[jolt].nil?

  return 1 if chargers.count == 1

  [1, 2, 3].map do |i|
    check = jolt + i
    pos = chargers.index(check)
    seen[check] = pos.nil? ? 0 : arrangements(check, chargers[pos..chargers.count], seen)
  end.sum
end

def part2(input)
  jolts = input.map(&:to_i).sort

  jolts << jolts[-1] + 3

  seen = {}

  arrangements(0, jolts, seen)
end

# puts part2(aoc.test_data2)

ans = part2(aoc.test_data2)

aoc.run(2, 19208, ans) { |data| part2(data) }

__END__
