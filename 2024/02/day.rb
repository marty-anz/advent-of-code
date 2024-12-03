#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def safe?(n)
  trend = n[0] > n[1]

  (1...n.count).all? do |i|
    n[i-1] > n[i] == trend && (1..3).includes?((n[i-1] - n[i]).abs)
  end
end

def part1(input)
  input
    .map{ |l| l.split(' ').map(&:to_i) }
    .sum { |n| safe?(n) ? 1 : 0 }
end

puts part1(aoc.test_data)

aoc.run(1, 1, 1) { |lines| part1(lines) }

def safe2?(n)
  (0...n.count).any? { |i| safe?(n[0...i] + n[i+1..]) }
end

def part2(input)
  input
    .map { |l| l.split(" ").map(&:to_i) }
    .filter { |n| safe2?(n) }
    .count
end

puts part2(aoc.test_data)

aoc.run(2, 1, 1) { |lines| part2(lines) }
