#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'
require '../../lib/deq'

Up = '^'
Down = 'v'
Left = '<'
Right = '>'

Blizard = 'B'
Empty = '.'
Elf = 'E'
Wall = '#'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def blizard?(c)
  [Up, Down, Left, Right].include?(c)
end

def parse(data)
  data.map do |line|
    line.chars.map do |c|
      blizard?(c) ? [Blizard, [c]] : [c, []]
    end
  end
end

def copy_map(map)
  size = M.size(map)
  new_map = M.make(*size, '.')

  map.each_with_index do |line, i|
    line.each_with_index do |v, j|
      if v[0] == Blizard
        new_map[i][j] = [Empty, []]
      else
        new_map[i][j] = [v[0], []]
      end
    end
  end

  new_map
end

def start_point
  [0, 1]
end

def end_point(map)
  row = map.size
  col = map.first.size
  [row - 1, col - 2]
end

def blizarding(map)
  sz = [map.size, map.first.size]

  new_map = copy_map(map)

  map.each_with_index do |row, r|
    row.each_with_index do |v, c|
      next if v[0] != Blizard

      v[1].each do |b|
        case b
        when Up
          nr, nc = r - 1, c
          xr, xc = sz.first - 2, c
        when Down
          nr, nc = r + 1, c
          xr, xc = 1, c
        when Left
          nr, nc = r, c - 1
          xr, xc = r, sz.last - 2
        when Right
          nr, nc = r, c + 1
          xr, xc = r, 1
        end

        # puts "#{r} #{c} #{nr} #{nc} #{map[r][c]}"

        if map[nr][nc][0] == Wall
          new_map[xr][xc][0] = Blizard
          new_map[xr][xc][1] << b
        else
          new_map[nr][nc][0] = Blizard
          new_map[nr][nc][1] << b
        end
      end
    end
  end

  new_map
end

def moving_positions(x, y, map)
  M.bounded_cross(map, x, y).select do |r, c|
    map[r][c][0] == Empty
  end
end

def snap(map)
  map.map do |r|
    r.map do |v|
      v[0] == Blizard ? v[1].size : v[0]
    end.join
  end.join
end

def reach_target(start, target, map)
  paths = [start]
  min = 0
  target_reached = false

  while !target_reached
    min += 1
    map = blizarding(map)
    new_paths = []

    paths.each do |pos|
      must_move = map[pos.first][pos.last][0] == Blizard
      positions = moving_positions(*pos, map)

      next if must_move && positions.empty? # deadend

      new_paths << pos if !must_move

      positions.each do |x|
        return min, map if x == target

        new_paths << x
      end
    end

    paths = new_paths.uniq
  end
end

def part1(data)
  map = parse(data)

  start = start_point
  target = end_point(map)

  min, _ = reach_target(start, target, map)
  min
end

puts 'part 1'

ans = part1(aoc.test_data)

puts ans

res = aoc.run(1, 18, ans) do |data|
  part1(data)
end

aoc.download if res

def part2(data)
  map = parse(data)

  start = start_point
  target = end_point(map)

  min0, map = reach_target(start, target, map)
  min1, map = reach_target(target, start, map)
  min2, _ = reach_target(start, target, map)

  puts [min0, min1, min2].to_s
  min0 + min1 + min2
end

puts 'part 2'

ans = part2(aoc.test_data)
puts ans

aoc.run(2, 54, ans) do |data|
  part2(data)
end
