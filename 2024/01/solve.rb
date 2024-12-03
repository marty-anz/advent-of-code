#!/usr/bin/env ruby
#
require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def part1(input)
  l1, l2 = [], []

  input.each do |l|
    a, b = l.split(" ").map(&:to_i)
    l1 << a
    l2 << b
  end

  l1.sort!
  l2.sort!

  (0...l1.count).sum { |i| (l1[i] - l2[i]).abs }
end

puts part1(aoc.test_data)

aoc.run(1, 1, 1) { |lines| part1(lines) }

def part2(input)
  l1, l2= [], {}

  input.each do |l|
    a, b = l.split(" ").map(&:to_i)
    l1 << a
    l2[b] = (l2[b] || 0) + 1
  end

  l1.sum { |e| e * (l2[e] || 0) }
end

puts part2(aoc.test_data)

aoc.run(2, 1, 1) { |lines| part2(lines) }
