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
end

ans = part1(aoc.test_data)

res = aoc.run(1, nil, ans) do |data|
  part1(data)
end

def part2(input)
end

ans = part2(aoc.test_data)

aoc.run(2, nil, ans) do |data|
  part2(data)
end
