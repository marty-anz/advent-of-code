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

def cross_edges(sz)
  [
    {
      Up => [5, boarder(3, sz), Right],
      Right => [1, boarder(3, sz), Right],
      Down => [2, boarder(0, sz), Down],
      Left => [3, boarder(3, sz).reverse, Right]
    },
    {
      Up => [5, boarder(2, sz), Up],
      Right => [4, boarder(1, sz).reverse, Left],
      Down => [2, boarder(1, sz), Left],
      Left => [0, boarder(1, sz), Left]
    },
    {
      Up => [0, boarder(2, sz), Up],
      Right => [1, boarder(2, sz), Up],
      Down => [4, boarder(0, sz), Down],
      Left => [3, boarder(0, sz), Down]
    },
    {
      Up => [2, boarder(3, sz), Right],
      Right => [4, boarder(3, sz), Right],
      Down => [5, boarder(0, sz), Down],
      Left => [0, boarder(3, sz).reverse, Right]
    },
    {
      Up => [2, boarder(2, sz), Up],
      Right => [1, boarder(1, sz).reverse, Left],
      Down => [5, boarder(1, sz), Left],
      Left => [3, boarder(1, sz), Left]
    },
    {
      Up => [3, boarder(2, sz), Up],
      Right => [4, boarder(2, sz), Up],
      Down => [1, boarder(0, sz), Down],
      Left => [0, boarder(0, sz), Down]
    }
  ]
end

def cross(side, facing, i, edges, sides)
  # cross edge

  new_side, edge, new_facing = edges[side][facing]
  new_row, new_col = edge[i]

  #  puts sides[new_side][new_row][new_col].to_s

  return false if sides[new_side][new_row][new_col][0] == '#'

  return true, [new_side, new_row, new_col, new_facing]
end

def move(side, row, col, facing, steps, edges, sides, sz)
  steps.times do
    case facing
    when Right
      next_row = row
      next_col = col + 1
      cross_index = row
    when Up
      next_row = row - 1
      next_col = col
      cross_index = col
    when Left
      next_row = row
      next_col = col - 1
      cross_index = row
    when Down
      next_row = row + 1
      next_col = col
      cross_index = col
    end

    if (0...sz).include?(next_row) && (0...sz).include?(next_col)
      return side, row, col, facing if sides[side][next_row][next_col][0] == '#'
      row, col = next_row, next_col
    else
      crossed, pos = cross(side, facing, cross_index, edges, sides)
      return side, row, col, facing unless crossed
      side, row, col, facing = pos
    end
  end

  return side, row, col, facing
end

def cut(map, offsets, sz)
  ms = []

  offsets.each do |x, y|
    m = M.make(sz, sz, nil)
    sz.times.each do |r|
      sz.times.each do |c|
        m[r][c] = [map[x + r][y + c], x + r, y + c]
      end
    end

    ms << m
  end

  return ms
end

def cross_edges_test(sz)
  [
    {
      Up => [1, boarder(0, sz).reverse, Down],
      Right => [5, boarder(1, sz).reverse, Left],
      Down => [3, boarder(0, sz), Down],
      Left => [2, boarder(0, sz), Down]
    },
    {
      Up => [0, boarder(0, sz).reverse, Down],
      Right => [2, boarder(3, sz), Right],
      Down => [4, boarder(2, sz).reverse, Up],
      Left => [5, boarder(2, sz).reverse, Up]
    },
    {
      Up => [0, boarder(3, sz), Right],
      Right => [3, boarder(3, sz), Right],
      Down => [4, boarder(3, sz).reverse, Right],
      Left => [1, boarder(1, sz), Left]
    },
    {
      Up => [0, boarder(2, sz), Up],
      Right => [5, boarder(0, sz).reverse, Down],
      Down => [4, boarder(0, sz), Down], #
      Left => [2, boarder(1, sz), Left]
    },
    {
      Up => [3, boarder(2, sz), Up],
      Right => [5, boarder(3, sz), Right],
      Down => [1, boarder(2, sz).reverse, Up],
      Left => [2, boarder(2, sz).reverse, Up]
    },
    {
      Up => [3, boarder(1, sz).reverse, Left],
      Right => [0, boarder(1, sz).reverse, Left],
      Down => [1, boarder(3, sz).reverse, Right],
      Left => [4, boarder(1, sz), Left]
    }
  ]
end

def parse(data)
  moves = data.pop

  moves = moves.gsub(/([RL])/, ' \1 ').split

  data.pop

  map = data.map do |line|
    line.chars[0..-2].map { |c| c == ' ' ? nil : c }
  end

  return map, moves
end

# map, _ = parse(aoc.data)
# _, sides = cut(map)

# sides[1].each do |l|
#   puts l.to_s
# end

def boarder(n, sz)
  case n
  when 0
    sz.times.map do |c|
      [0, c]
    end
  when 1
    sz.times.map do |r|
      [r, sz - 1]
    end
  when 2
    sz.times.map do |c|
      [sz - 1, c]
    end
  when 3
    sz.times.map do |r|
      [r, 0]
    end
  end
end

# exit

def part2_test(data)
  map, moves = parse(data)
  offsets = [[0, 8], [4, 0], [4, 4], [4, 8], [8, 8], [8, 12]]
  sz = 4
  sides = cut(map, offsets, sz)

  edges = cross_edges_test(sz)

  side, row, col = 0, 0, 0

  facing = Right

  moves.each do |x|
    # puts "move #{x}"
    if x == 'R' || x == 'L'
      facing = turn_facing(facing, x)
      # puts [*sides[side][row][col][1..], facing].to_s
    else
      steps = x.to_i
      side, row, col, facing = move(side, row, col, facing, steps, edges, sides, sz)

      # puts [*sides[side][row][col][1..], facing].to_s
    end
  end

  # puts [side, row, col, facing].to_s

  # puts row_ranges.to_s
  # puts column_ranges.to_s

  puts [*sides[side][row][col][1..], facing].to_s

  row, col = *sides[side][row][col][1..]

  password(row + 1, col + 1, facing)
end

part2_test(aoc.test_data)

# exit

def part2(data)
  map, moves = parse(data)
  offsets = [[0, 50], [0, 100], [50, 50], [100, 0], [100, 50], [150, 0]]
  sz = 50
  sides = cut(map, offsets, sz)

  edges = cross_edges(50)

  side, row, col = 0, 0, 0

  facing = Right

  moves.each do |x|
    if x == 'R' || x == 'L'
      facing = turn_facing(facing, x)
    else
      steps = x.to_i
      side, row, col, facing = move(side, row, col, facing, steps, edges, sides, sz)
    end
  end

  # puts [side, row, col, facing].to_s

  # puts row_ranges.to_s
  # puts column_ranges.to_s

  row, col = sides[side][row][col][1..]
  puts [side, row, col].to_s
  password(row + 1, col + 1, facing)
end

tb = 5031

puts 'part 2'

ans = part2_test(aoc.test_data)

part2(aoc.data)

aoc.run(2, tb, ans) do |data|
  part2(data)
end
