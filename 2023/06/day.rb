#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def ways_to_beat(time, best)
  time.times.map do |i|
    i * (time - i)
  end.filter { |t| t > best }.count
end

def part1(input)
  times = input[0].split(":")[1].split(" ").map(&:to_i)
  distances = input[1].split(":")[1].split(" ").map(&:to_i)

  counts = []
  times.each_with_index do |t, i|
    counts << ways_to_beat(t, distances[i])
  end

  counts.inject(&:*)
end

ans = part1(aoc.test_data)

aoc.run(1, 288, ans) { |data| part1(data) }

def part2(input)
  time = input[0].split(":")[1].split(" ").map(&:strip).join.to_i
  distance = input[1].split(":")[1].split(" ").map(&:strip).join.to_i

  ways_to_beat(time, distance)
end

ans = part2(aoc.test_data)

aoc.run(2, 71503, ans) { |data| part2(data) }
