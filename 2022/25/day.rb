#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'
require '../../lib/deq'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

Digits = {
  '2' => 2,
  '1' => 1,
  '0' => 0,
  '-' => -1,
  '=' => -2
}

# [2, 1, 0, '-', '=']

def snafu_to_i(n)
  pos = 1
  dec = 0

  n.reverse.each_with_index do |x, i|
    dig = Digits[x]

    dec += dig * pos
    pos *= 5
  end

  dec
end

def i_to_snafu(i)
  pen = i.to_s(5).chars.map(&:to_i)

  pen = [0] + pen

  (1...pen.size).to_a.reverse.each do |p|
    x = pen[p]
    if x == 4
      pen[p] = -1
      pen[p - 1] += 1
    elsif x == 3
      pen[p] = -2
      pen[p - 1] += 1
    elsif x >= 5
      pen[p] = x - 5
      pen[p - 1] += 1
    end
  end

  s = pen.map do |x|
    if x == -1
      '-'
    elsif x == -2
      '='
    else
      x.to_s
    end
  end.join

  s.sub(/^0+/, '')
end

# puts snafu_to_i('2=-01'.chars)
# puts snafu_to_i('1121-1110-1=0'.chars)
# # #
# puts i_to_snafu(976).to_s
# puts i_to_snafu(314159265).to_s

# puts snafu_to_i('2=-0=01----22-0-1-10'.chars) == 29694520452605

def part1(data)
  s = data.map do |l|
    snafu_to_i(l.chars)
  end.sum

  puts "sum #{s}"

  i_to_snafu(s)
end

puts 'part 1'

ans = part1(aoc.test_data)

puts ans

puts part1(aoc.data)
exit

# 2=-0=01----22-0-1-10
#
# res = aoc.run(1, '2=-1=0', ans) do |data|
#   part1(data)
# end

# aoc.download if res

# def part2(data)
# end

# puts 'part 2'

# ans = part2(aoc.test_data)
# puts ans

# aoc.run(2, nil, ans) do |data|
#   part2(data)
# end
