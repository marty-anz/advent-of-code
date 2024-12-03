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
  input.join.scan(/mul\(\d+,\d+\)/).sum do |m|
    m.scan(/\d+/).map(&:to_i).inject(:*)
  end
end

puts part1(aoc.test_data)

puts part1(aoc.data)

def part2(input)
  stop = false

  input.join.scan(/mul\(\d+,\d+\)|do\(\)|don\'t\(\)/).filter_map do |m|
    stop = m == "don't()"  if m.start_with?('do')

    m if !stop
  end.filter { |m| m.start_with? 'mul'}.sum {|m| m.scan(/\d+/).map(&:to_i).inject(:*) }
end

puts part2(["xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"])

puts part2(aoc.data)
