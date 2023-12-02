#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def valid?(i, n, lst)
  lst[(i - n)...i].combination(2).select do |a, b|
    a != b
  end.each do |a, b|
    return true if (a + b) == lst[i]
  end

  false
end

def part1(input, n)
  numbers = input.map do |x|
    x.to_i
  end

  (n...numbers.count).each do |i|
    return numbers[i] if !valid?(i, n, numbers)
  end

  0
end

ans = part1(aoc.test_data, 5)

aoc.run(1, 127, ans) { |data| part1(data, 25) }

def part2(input, s)
  ns = input.map do |x|
    x.to_i
  end


  x, i, j = ns[0], 0, 1

  while true
    while x < s
      x += ns[j]
      j += 1
    end


    return ns[i...j].min + ns[i...j].max    if x == s

    x, i, j = ns[i+1], i+1, i+2
  end

  0
end

######
# 0 1 2 3 4 5 6
#
####
ans = part2(aoc.test_data, 127)

aoc.run(2, 62, ans) { |data| part2(data, 18272118) }
