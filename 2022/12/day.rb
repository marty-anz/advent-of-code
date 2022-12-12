#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence' # S

ROW, COL = 0, 1

INF = 999999999

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

ta = 31

def build_graph(matrix)
  Graph.build_graph(matrix) do |g, m, x, y|
    M.bounded_cross(m, x, y).each do |nei|
      value = m[x][y]

      value = 'a' if value == 'S'
      value = 'z' if value == 'E'

      other = m[nei[ROW]][nei[COL]]

      other = 'a' if m[nei[ROW]][nei[COL]] == 'S'
      other = 'z' if m[nei[ROW]][nei[COL]] == 'E'

      next if (other.ord - value.ord) > 1

      g[[x, y]][nei] = 1
    end
  end
end

def part1(data)
  m = data.map { |line| line.chars }

  start, target = nil, nil

  M.each(m) do |e, r, c|
    if e == 'S'
      start = [r, c]
    elsif e == 'E'
      target = [r, c]
    end
  end

  g = build_graph(m)

  Graph.shortest(g, start, target).first[target]
end

tb = 29

def part2(data)
  m = data.map { |line| line.chars }

  start, target = [], nil

  M.each(m) do |e, r, c|
    if ['S', 'a'].include? e
      start << [r, c]
    elsif e == 'E'
      target = [r, c]
    end
  end

  g = build_graph(m)

  start.map do |s|
    Graph.shortest(g, s, target).first[target]
  end.min
end

puts 'part 1'

ans = part1(aoc.test_data)

res = aoc.run(1, ta, ans) do |data|
  part1(data)
end

aoc.download if res && tb.nil?

puts 'part 2'

ans = part2(aoc.test_data)

aoc.run(2, tb, ans) do |data|
  part2(data)
end

puts 'done'
