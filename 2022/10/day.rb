#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/sequence' # S

ROW = 0
COL = 1

aoc = Aoc.new(__dir__) do |data|
  data.map(&:split)
end

ta = 13140

def part1(data)
  x = 1
  cycle = 0

  s = []

  data.each do |c, o|
    cycle += 1

    # during 1st cycle
    if [220, 20, 60, 100, 140, 180].include? cycle
      # puts "1 #{cycle} #{x}"
      s << (x * cycle)
    end

    # puts "cycle #{cycle} #{c} #{o} #{x}"

    next if c == 'noop'

    # during second cycle
    cycle += 1 # during

    if [220, 20, 60, 100, 140, 180].include? cycle
      # puts "2 #{cycle} #{x}"
      s << (x * cycle)
    end

    x += o.to_i
  end

  s.sum
end

tb = 10

def part2(data)
  crt = M.make(6, 40, '.')

  x = 1
  cycle = 0

  add = nil

  data.each do |c, o|
    cycle += 1

    # during 1st cycle
    row = cycle / 40
    col = cycle - row * 40

    if [x, x + 1, x + 2].include? col
      crt[row][col] = '#'
    end

    next if c == 'noop'

    # dfuring second cycle
    cycle += 1 # during

    row = cycle / 40
    col = cycle - row * 40

    if [x, x + 1, x + 2].include? col
      crt[row][col] = '#'
    end

    x += o.to_i
  end

  M.print(crt)

  1
end

ans = part1(aoc.test_data)

res = aoc.run(1, ta, ans) do |data|
  part1(data)
end

aoc.download if res && tb.nil?

ans = part2(aoc.test_data)

aoc.run(2, tb, ans) do |data|
  part2(data)
end

puts 'done'

#
# EEFGERURE
#
