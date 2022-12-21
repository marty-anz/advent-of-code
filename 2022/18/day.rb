#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def cube(x, y, z)
  x, y, z = x - 1, y - 1, z - 1

  orth = [
    [[x, y, z], [x + 1, y, z], [x + 1, y + 1, z], [x, y + 1, z]],
    [[x + 1, y, z], [x + 1, y, z + 1], [x + 1, y + 1, z + 1], [x + 1, y + 1, z]],
    [[x + 1, y, z + 1], [x, y, z + 1], [x, y + 1, z + 1], [x + 1, y + 1, z + 1]],
    [[x, y, z + 1], [x, y, z], [x, y + 1, z], [x, y + 1, z + 1]],
    [[x, y + 1, z], [x + 1, y + 1, z], [x + 1, y + 1, z + 1], [x, y + 1, z + 1]],
    [[x, y, z], [x + 1, y, z], [x + 1, y, z + 1], [x, y, z + 1]]
  ]

  sorted = orth.map do |s|
    s.sort
  end

  return orth, sorted
end

puts 'part 1'

def part1(data)
  cubes = data.map do |line|
    cube(*line.split(',').map(&:to_i))
  end

  counts = {}

  cubes.each do |_, c|
    c.each do |side|
      counts[side] = counts[side].to_i + 1
    end
  end

  counts.select do |_, k|
    k == 1
  end.size
end

def scan_layer(n, unchecked, known_exposed, exposed, points)
  return if unchecked.empty?

  while !known_exposed.empty?
    x, y, z = known_exposed.shift

    [
      [x + 1, y, z],
      [x - 1, y, z],
      [x, y + 1, z],
      [x, y - 1, z]
    ].reject { |c| points[c] }
      .reject { |c| exposed[c] }
      .each do |c|
      exposed[c] = true
      known_exposed << c
    end
  end

  unchecked.reject! do |x, y, z|
    e = [
      [x + 1, y, z],
      [x - 1, y, z],
      [x, y + 1, z],
      [x, y - 1, z],
      [x, y, z - 1],
      [x, y, z + 1]
    ].any? do |c|
      !points[p] && exposed[c]
    end

    exposed[[x, y, z]] = true if e
  end
end

def find_trapped(points)
  points_map = Hash[points.map { |x| [x, true] }]

  exposed = {}
  trapped = {}

  min = points.flatten.min
  max = points.flatten.max

  min = min - 1
  max = max + 1

  # mark surface
  [min, max].each do |z|
    (min..max).each do |x|
      (min..max).each do |y|
        p = [x, y, z]
        exposed[p] = true
      end
    end
  end

  [min, max].each do |x|
    (min..max).each do |z|
      (min..max).each do |y|
        p = [x, y, z]
        exposed[p] = true
      end
    end
  end

  [min, max].each do |y|
    (min..max).each do |z|
      (min..max).each do |x|
        p = [x, y, z]
        exposed[p] = true
      end
    end
  end

  min = min + 1
  max = max - 1

  air = {}

  # z
  (min..max).map do |z|
    unchecked = []
    known_exposed = []

    (min..max).each do |x|
      (min..max).each do |y|
        p = [x, y, z]

        next if points_map[p]

        air[p] = true
        if exposed[p]
          known_exposed << p
        else
          unchecked << p
        end
      end
    end

    scan_layer(z, unchecked, known_exposed, exposed, points_map)
  end

  (min..max).to_a.reverse.map do |z|
    unchecked = []
    known_exposed = []

    (min..max).each do |x|
      (min..max).each do |y|
        p = [x, y, z]

        next if points_map[p]

        air[p] = true

        if exposed[p]
          known_exposed << p
        else
          unchecked << p
        end
      end
    end

    scan_layer(z, unchecked, known_exposed, exposed, points_map)
  end

  puts 'scan up'

  air.keys.each do |p|
    trapped[p] = true unless exposed[p]
  end

  trapped
end

def count_single_sides(points)
  counts = {}

  points.each do |p|
    _, sides = cube(*p)
    sides.each do |side|
      counts[side] = counts[side].to_i + 1
    end
  end

  return counts.select { |_, k| k == 1 }.size
end

# _, missing, trapped, _, _ = find_missing_surface(
#   [
#     [1, 1, 1], [1, 1, 2], # [2, 1, 1],
#     [3, 1, 1], [3, 1, 2], [2, 2, 2],
#     [2, 0, 2], [2, 1, 3],
#     [2, 2, 1], [2, 1, 0], [2, 0, 1]
#   ]
# )

# puts "missing #{missing[[2, 1, 2]]}"
# puts "trapped #{trapped.keys}"

# puts "single sides #{count_single_sides(trapped.keys)}"
# exit

def part2(data)
  points = data.map { |line| line.split(',').map(&:to_i) }

  total_single_sides = count_single_sides(points)

  # puts "total single sides: #{total_sides}"

  trapped = find_trapped(points)

  trapped_sides = count_single_sides(trapped.keys)

  total_single_sides - trapped_sides
end

ta = 64

ans = part1(aoc.test_data)

puts ans

res = aoc.run(1, ta, ans) do |data|
  part1(aoc.data)
end

tb = 58

puts 'part 2'

ans = part2(aoc.test_data)

puts "#{ans} should be #{tb}"

# 2608 too high

# puts part2(aoc.data)

aoc.run(2, tb, ans) do |data|
  part2(data)
end

puts 'done'
