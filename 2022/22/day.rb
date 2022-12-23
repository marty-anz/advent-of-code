#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'
require '../../lib/deq'

aoc = Aoc.new(__dir__) do |data|
  data
end

Right = 0
Down = 1
Left = 2
Up = 3

def password(row, column, facing)
  row * 1000 + column * 4 + facing
end

def turn_facing(facing, direct)
  if direct == 'R'
    case facing
    when Right
      Down
    when Down
      Left
    when Left
      Up
    when Up
      Right
    end
  else
    case facing
    when Right
      Up
    when Up
      Left
    when Left
      Down
    when Down
      Right
    end
  end
end

# puts turn_facing(Right, 'L') == Up

def move(row, col, facing, steps, row_ranges, col_ranges, map)
  case facing
  when Right
    while steps > 0
      next_col = col + 1
      if !row_ranges[row].include?(next_col)
        next_col = row_ranges[row].first
      end

      break if map[row][next_col] == '#'
      steps -= 1
      col = next_col
    end
  when Up
    while steps > 0
      next_row = row - 1
      if !col_ranges[col].include?(next_row)
        next_row = col_ranges[col].last
      end

      break if map[next_row][col] == '#'
      steps -= 1
      row = next_row
    end
  when Left
    while steps > 0
      next_col = col - 1
      if !row_ranges[row].include?(next_col)
        next_col = row_ranges[row].last
      end

      break if map[row][next_col] == '#'
      steps -= 1
      col = next_col
    end
  when Down
    while steps > 0
      next_row = row + 1
      if !col_ranges[col].include?(next_row)
        next_row = col_ranges[col].first
      end

      break if map[next_row][col] == '#'
      steps -= 1
      row = next_row
    end
  end

  return row, col
end

ta = 6032

def part1(data)
  moves = data.pop

  moves = moves.gsub(/([RL])/, ' \1 ').split

  data.pop

  facing = Right

  map = data.map do |line|
    line.chars[0..-2].map { |c| c == ' ' ? nil : c }
  end

  row_ranges = map.each_with_index.map do |row, r|
    s = row.find_index { |x| x != nil }
    s..(row.size - 1)
  end

  columns = map.map { |r| r.size }.max

  col_ranges = columns.times.map do |c|
    s = map.find_index { |r| r[c] != nil }
    e = (0...map.size).to_a.reverse.find do |r|
      map[r][c] != nil
    end
    s..e
  end

  # puts row_ranges.to_s
  # puts column_ranges.to_s

  row, col = [0, row_ranges[0].first]

  puts [row, col].to_s

  moves.each do |x|
    if x == 'R' || x == 'L'
      facing = turn_facing(facing, x)
    else
      steps = x.to_i
      row, col = move(row, col, facing, steps, row_ranges, col_ranges, map)
    end
  end

  puts [row, col, facing].to_s

  password(row + 1, col + 1, facing)
end

tb = nil

def part2(data)
end

puts 'part 1'

ans = part1(aoc.test_data)

puts ans

res = aoc.run(1, ta, ans) do |data|
  part1(data)
end

aoc.download if res && tb.nil?
puts 'part 2'

ans = part2(aoc.test_data)

aoc.run(2, tb, ans) do |data|
  part2(data)
end
