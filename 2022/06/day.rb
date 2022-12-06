#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash'
require '../../lib/matrix'
require '../../lib/sequence'

aoc = Aoc.new(__dir__) { |data| data.first.chars }

ta = 7

def part1(data)
  data.count.times do |i|
    return i + 4 if data[i..(i + 3)].uniq.size == 4
  end
end

tb = 19

def part2(data)
  data.count.times do |i|
    return i + 14 if data[i..(i + 13)].uniq.size == 14
  end
end

ans = part1(aoc.test_data)

res = aoc.run(1, ta, ans) do |data|
  part1(data)
end

# download puzzle.md again once part1 is solved
# do not donwload again if I have found what the test b is
aoc.download if res && tb.nil?

ans = part2(aoc.test_data)

aoc.run(2, tb, ans) do |data|
  part2(data)
end

puts 'done'
