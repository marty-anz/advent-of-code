#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/sequence' # S

aoc = Aoc.new(__dir__) do |data|
  data.map do |l|
    l.chars.map(&:to_i)
  end
end

ta = 21

def visible?(data, r, c, row, col)
  return true if r == 0 || c == 0 || r == (row - 1) || c == (col - 1)

  return true if M.up(data, r, c).all? { |x, y| data[x][y] < data[r][c] }

  return true if M.down(data, r, c).all? { |x, y| data[x][y] < data[r][c] }

  return true if M.left(data, r, c).all? { |x, y| data[x][y] < data[r][c] }

  return true if M.right(data, r, c).all? { |x, y| data[x][y] < data[r][c] }

  false
end

def part1(data)
  row, col = M.dim(data)

  M.map(data) { |_, r, c| visible?(data, r, c, row, col) ? 1 : 0 }.sum
end

def su(data, r, c, _, _)
  M.up(data, r, c).each_with_index do |(x, _), i|
    return i + 1 if data[x][c] >= data[r][c]
  end

  r
end

def sd(data, r, c, row, _)
  M.down(data, r, c).each_with_index do |(x, _), i|
    return i + 1 if data[x][c] >= data[r][c]
  end

  row - r - 1
end

def sl(data, r, c, _, _)
  M.left(data, r, c).each_with_index do |(_, x), i|
    return i + 1 if data[r][x] >= data[r][c]
  end
  c
end

def sr(data, r, c, _, col)
  M.right(data, r, c).each_with_index do |(_, x), i|
    return i + 1 if data[r][x] >= data[r][c]
  end
  col - c - 1
end

def score(data, r, c, row, col)
  su(data, r, c, row, col) * sd(data, r, c, row, col) * sl(data, r, c, row, col) * sr(data, r, c, row, col)
end

tb = 8

def part2(data)
  row, col = M.dim(data)

  M.map(data) { |_, r, c| score(data, r, c, row, col) }.max
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
