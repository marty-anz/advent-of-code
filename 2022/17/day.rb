#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

puts 'part 1'

ROCKS = [
  [[0, 0], [0, 1], [0, 2], [0, 3]],
  [
    [0, 1], [1, 0], [1, 1], [1, 2], [2, 1]
  ],
  [
    [0, 0], [0, 1], [0, 2],
    [1, 2], [2, 2]
  ],
  [
    [0, 0], [1, 0], [2, 0], [3, 0]
  ],
  [[0, 0], [0, 1], [1, 0], [1, 1]]
]

def release_rock(n)
  i = n % 5
  ROCKS[i].map do |x|
    x.clone
  end
end

def place_rock(rock, top)
  rock.map do |x, y|
    [x + top + 3, y + 2]
  end
end

def move_left(rock, rocks)
  rock = rock.map do |x, y|
    return rock, false if (y - 1) < 0
    p = [x, y - 1]
    return rock, false if rocks[p]

    p
  end

  return rock, true
end

def move_right(rock, rocks)
  rock = rock.map do |x, y|
    return rock, false if (y + 1) >= 7
    p = [x, y + 1]
    return rock, false if rocks[p]

    p
  end

  return rock, true
end

def fall(rock, rocks)
  rock = rock.map do |x, y|
    return rock, false if (x - 1) < 0

    p = [x - 1, y]

    return rock, false if rocks[p]

    p
  end

  return rock, true
end

def part1(data)
  jets = data.first

  max_rock = 2022
  count = 0

  top = -1

  rocks = {}

  jet_size = jets.size

  jet_index = 0

  while count < max_rock
    count += 1

    rock = release_rock(count)
    # puts rock.to_s

    rock = place_rock(rock, top + 1)

    #    puts "#{count} #{rock}"

    moving = true

    while moving
      jet = jets[jet_index % jet_size]

      #     puts "#{count} #{jet}"

      if jet == '<'
        rock, _ = move_left(rock, rocks)
      else
        rock, _ = move_right(rock, rocks)
      end

      rock, moving = fall(rock, rocks)
      jet_index += 1
    end

    rock.each do |co|
      rocks[co] = true
      if top < co[0]
        top = co[0]
      end
    end
  end

  top + 1
end

def part2(data)
  jets = data.first

  max_rock = 1_000_000_000_000

  count = 0

  top = -1

  rocks = {}

  jet_size = jets.size

  jet_index = 0

  cached = {}

  while count < max_rock
    rock = release_rock(count)

    rock = place_rock(rock, top + 1)

    moving = true

    while moving
      jet = jets[jet_index]

      if jet == '<'
        rock, _ = move_left(rock, rocks)
      else
        rock, _ = move_right(rock, rocks)
      end

      rock, moving = fall(rock, rocks)
      jet_index = (jet_index + 1) % jet_size
    end

    rock.each do |co|
      rocks[co] = true
      top = co[0] if top < co[0]
    end

    pic = []

    4.times do |r|
      7.times do |i|
        pic[i] = rocks[[top - r, i]] ? '#' : '.' if pic[i] != '#'
      end
    end

    layer = pic.join

    key = "#{count % 5}-#{jet_index}-#{layer}"

    if layer == '#######'
      if cached[key].nil?
        cached[key] = {
          top: top,
          count: count,
          jet_index: jet_index
        }
      else
        puts "repeat... #{key} #{top} #{cached[key]} #{count} #{jet_index}"

        step = count - cached[key][:count]
        times = (max_rock - count) / step
        delta = top - cached[key][:top]

        count += step * times
        old_top = top
        top += delta * times

        4.times do |r|
          7.times do |i|
            rocks[[top - r, i]] = rocks[[old_top - r, i]]
          end
        end
      end
    end

    count += 1
  end

  top + 1
end

ta = 3068

ans = part1(aoc.test_data)

puts ans

res = aoc.run(1, ta, ans) do |data|
  part1(data)
end

tb = 1514285714288
# 1514285714287
# 1514285714288
# 1537647058825
# 1537647058825
# aoc.download if res && tb.nil?

puts 'part 2'

ans = part2(aoc.test_data)

puts ans

aoc.run(2, tb, ans) do |data|
  part2(data)
end

puts 'done'
