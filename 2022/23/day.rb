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

North = 'N'
South = 'S'
West = 'W'
East = 'E'

def mins(map)
  min_x, max_x = INF, -INF
  min_y, max_y = INF, -INF

  map.select { |_, v| v == '#' }.keys.each do |x, y|
    min_x = x if x < min_x

    min_y = y if y < min_y

    max_x = x if x > max_x

    max_y = y if y > max_y
  end

  return min_x..max_x, min_y..max_y
end

def display(map)
  xr, yr = mins(map)

  xr.each do |x|
    line = yr.map do |y|
      map[[x, y]] || '.'
    end

    puts line.join
  end

  puts '------'
end

def count_empty_tiles(map)
  x_r, y_r = mins(map)

  count = 0

  x_r.each do |x|
    y_r.each do |y|
      count += 1 if map[[x, y]] != '#'
    end
  end

  count
end

def sim(map, choice, direction)
  count = 0
  proposing_elfs = {}

  # first half
  map.select { |_, v| v == '#' }.each do |p, _|
    x, y = p

    surroudings = M.surrounding(x, y)

    if surroudings.any? { |p| map[p] == '#' }
      choice.each_with_index do |spots, i|
        if spots.all? { |si| map[surroudings[si]] != '#' }
          proposed = surroudings[M::SurroundingDirection[direction[i]]]

          proposing_elfs[proposed] = [] if proposing_elfs[proposed].nil?
          proposing_elfs[proposed] << p

          break
        end
      end
    end
  end

  # second half
  proposing_elfs.each do |dest, elf|
    next if elf.size > 1

    map[elf[0]] = nil
    map[dest] = '#'
    count += 1
  end

  count
end

def part1(data)
  map = {}

  data.each_with_index do |line, i|
    line.chars.each_with_index do |v, j|
      map[[i, j]] = v
    end
  end

  choice = [
    [M::SurroundingDirection['N'], M::SurroundingDirection['NE'], M::SurroundingDirection['NW']],
    [M::SurroundingDirection['S'], M::SurroundingDirection['SE'], M::SurroundingDirection['SW']],
    [M::SurroundingDirection['W'], M::SurroundingDirection['NW'], M::SurroundingDirection['SW']],
    [M::SurroundingDirection['E'], M::SurroundingDirection['NE'], M::SurroundingDirection['SE']]
  ]

  direction = ['N', 'S', 'W', 'E']

  10.times do
    sim(map, choice, direction)
    # display(map)
    choice = choice[1..] + [choice[0]]
    direction = direction[1..] + [direction[0]]
  end

  # display(map)

  count_empty_tiles(map)
end

puts 'part 1'

ans = part1(aoc.test_data)

puts ans

res = aoc.run(1, 110, ans) do |data|
  part1(data)
end

# aoc.download if res

def part2(data)
  map = {}

  data.each_with_index do |line, i|
    line.chars.each_with_index do |v, j|
      map[[i, j]] = v
    end
  end

  choice = [
    [M::SurroundingDirection['N'], M::SurroundingDirection['NE'], M::SurroundingDirection['NW']],
    [M::SurroundingDirection['S'], M::SurroundingDirection['SE'], M::SurroundingDirection['SW']],
    [M::SurroundingDirection['W'], M::SurroundingDirection['NW'], M::SurroundingDirection['SW']],
    [M::SurroundingDirection['E'], M::SurroundingDirection['NE'], M::SurroundingDirection['SE']]
  ]

  direction = ['N', 'S', 'W', 'E']

  round = 0
  while true
    round += 1
    count = sim(map, choice, direction)

    break if count == 0
    # display(map)
    choice = choice[1..] + [choice[0]]
    direction = direction[1..] + [direction[0]]
  end

  # display(map)

  round
end

puts 'part 2'

ans = part2(aoc.test_data)
puts ans

aoc.run(2, 20, ans) do |data|
  part2(data)
end
