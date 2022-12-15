#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def move_pos(x, y, min_x, max_x, min_y, max_y)
  down = y + 1
  right = x + 1
  left = x - 1

  [[x, down], [left, down], [right, down]].select do |a, b|
    a >= min_x && a <= max_x && y >= min_y && y <= max_y
  end
end

def part1(data)
  rocks = {}
  data.each do |line|
    lst = line.split('->').map(&:strip).map do |co|
      co.split(',').map(&:to_i)
    end

    rocks[lst.first] = true

    (1...lst.size).each do |i|
      pre = lst[i - 1]
      cur = lst[i]
      if pre[0] == cur[0]
        if pre[1] < cur[1]
          ((pre[1] + 1)..cur[1]).each do |y|
            rocks[[pre[0], y]] = true
          end
        else
          ((cur[1])...pre[1]).each do |y|
            rocks[[pre[0], y]] = true
          end
        end
      else
        if pre[0] < cur[0]
          ((pre[0] + 0)..cur[0]).each do |x|
            rocks[[x, pre[1]]] = true
          end
        else
          ((cur[0])...pre[0]).each do |x|
            rocks[[x, pre[1]]] = true
          end
        end
      end
    end
  end

  min_x, max_x = nil, nil
  min_y, max_y = nil, nil

  rocks.keys.each do |x, y|
    min_x = x if min_x.nil? || x < min_x
    max_x = x if max_x.nil? || x > max_x

    min_y = y if min_y.nil? || y < min_y
    max_y = y if max_y.nil? || y > max_y
  end

  min_x = 100
  max_x = [501, max_x].max

  min_y = 0
  max_y += 10

  void = false

  count = 0

  sand = {}
  while !void
    sx, sy = [500, 0]

    moving = true

    while moving
      pos = move_pos(sx, sy, min_x, max_x, min_y, max_y)

      pos = pos.reject do |x, y|
        rocks[[x, y]] || sand[[x, y]]
      end

      if pos.empty?
        moving = false

        if rocks[[sx, sy + 1]] || sand[[sx, sy + 1]]
          # rested
          sand[[sx, sy]] = true
          count += 1
        else
          void = true
        end
      else
        sx, sy = pos.first
      end
    end
  end

  count
end

tb = 93

def part2(data)
  rocks = {}
  data.each do |line|
    lst = line.split('->').map(&:strip).map do |co|
      co.split(',').map(&:to_i)
    end

    rocks[lst.first] = true

    (1...lst.size).each do |i|
      pre = lst[i - 1]
      cur = lst[i]
      if pre[0] == cur[0]
        if pre[1] < cur[1]
          ((pre[1] + 1)..cur[1]).each do |y|
            rocks[[pre[0], y]] = true
          end
        else
          ((cur[1])...pre[1]).each do |y|
            rocks[[pre[0], y]] = true
          end
        end
      else
        if pre[0] < cur[0]
          ((pre[0] + 0)..cur[0]).each do |x|
            rocks[[x, pre[1]]] = true
          end
        else
          ((cur[0])...pre[0]).each do |x|
            rocks[[x, pre[1]]] = true
          end
        end
      end
    end
  end

  min_x, max_x = nil, nil
  min_y, max_y = nil, nil

  rocks.keys.each do |x, y|
    min_x = x if min_x.nil? || x < min_x
    max_x = x if max_x.nil? || x > max_x

    min_y = y if min_y.nil? || y < min_y
    max_y = y if max_y.nil? || y > max_y
  end

  min_x = -99999
  max_x = 99999

  min_y = 0
  max_y += 2

  void = false

  count = 0

  sand = {}
  while !void
    sx, sy = [500, 0]

    moving = true

    while moving
      pos = move_pos(sx, sy, min_x, max_x, min_y, max_y)

      pos = pos.reject do |x, y|
        y == max_y || rocks[[x, y]] || sand[[x, y]]
      end

      if pos.empty?
        moving = false

        if [sx, sy] == [500, 0]
          void = true
        else
          sand[[sx, sy]] = true
          count += 1
        end
      else
        sx, sy = pos.first
      end
    end
  end

  count + 1
end

puts 'part 1'

ta = 24

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

puts 'done'
