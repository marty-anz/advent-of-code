#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def part1(nums)
  pairs = Hash[
    nums.map(&:to_i).map do |x|
      [x, 2020 - x.to_i]
    end
  ]

  pairs.each do |x, y|
    return x * y  unless pairs[y].nil?
  end
end

puts part1(aoc.test_data)
puts part1(aoc.data)

def part2(nums)
    nums = nums.map(&:to_i)

    doubles = []
    nums.each_with_index.map do |x, i|
      nums.each_with_index.map do |y, j|
        doubles << [x, y] if i != j
      end
    end

    matches = doubles.map do |pair|
      [pair, 2020 - pair[0] - pair[1]]
    end

    matches.each do |pair, y|
      return pair[0] * pair[1] * y if nums.include? y
    end
end

puts part2(aoc.test_data)
puts part2(aoc.data)
