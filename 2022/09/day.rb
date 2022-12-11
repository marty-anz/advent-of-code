#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/sequence' # S

ROW = 0
COL = 1

aoc = Aoc.new(__dir__) do |data|
  data.map(&:split).map { |x, y| [x, y.to_i] }
end

ta = 88

def surrounding(r, c)
  up, down, right, left = r - 1, r + 1, c + 1, c - 1

  [
    [up, c], [r, right], [down, c], [r, left],
    [up, left], [up, right], [down, right], [down, left]
  ]
end

def adj?(head, tail)
  head == tail || surrounding(head[ROW], head[COL]).include?(tail)
end

def part1(data)
  tail = [4, 0]
  head = [4, 0]

  tails = []

  tails = {}
  tails[tail] = true
  data.each do |d, steps|
    steps.times do
      old_head = [head[ROW], head[COL]]

      if d == 'R'
        head[COL] += 1
      elsif d == 'L'
        head[COL] -= 1
      elsif d == 'U'
        head[ROW] -= 1
      else # d == 'D'
        head[ROW] += 1
      end

      if !adj?(head, tail)
        tail = old_head

        tails[tail] = true
      end
    end
  end

  tails.count
end

tb = 35

def move(head, tail)
  if head[ROW] == tail[ROW]
    tail[COL] += tail[COL] > head[COL] ? -1 : 1
  elsif head[COL] == tail[COL]
    tail[ROW] += tail[ROW] > head[ROW] ? -1 : 1
  else
    # move both
    if tail[COL] > head[COL]
      tail[COL] -= 1
    else
      tail[COL] += 1
    end

    if tail[ROW] > head[ROW]
      tail[ROW] -= 1
    else
      tail[ROW] += 1
    end
  end
end

def part2(data)
  rope = 10.times.map do
    [4, 0]
  end

  tails = {}

  tails[rope[-1]] = true

  data.each do |d, steps|
    # puts "#{d} #{steps}"

    steps.times do |s|
      head = rope[ROW]

      if d == 'R'
        head[COL] += 1
      elsif d == 'L'
        head[COL] -= 1
      elsif d == 'U'
        head[ROW] -= 1
      else # d == 'D'
        head[ROW] += 1
      end

      9.times do |x|
        head = rope[x]
        tail = rope[x + 1]

        move(head, tail) if !adj?(head, tail)
      end

      tails[rope[-1]] = true
    end
  end

  tails.count
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
