#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'
require_relative './input'
require_relative './test_input'

ROW, COL = 0, 1

INF = 999999999

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

ta = 13

def list?(a)
  a.kind_of?(Array)
end

def valid?(l, r)
  status = 'nil'

  return 'nil' if l == r

  pos = 0

  while true
    return 'true' if pos == l.size && pos < r.size
    return 'false' if pos < l.size && pos == r.size

    return status if pos == l.size && pos == r.size

    a = l[pos]
    b = r[pos]

    if !list?(a) && !list?(b)
      if a < b
        return 'true'
      elsif a > b
        return 'false'
      else
        status = 'nil'
      end
    elsif list?(a) && list?(b)
      status = valid?(a, b)
    elsif list?(a) && !list?(b)
      status = valid?(a, [b])
    elsif !list?(a) && list?(b)
      status = valid?([a], b)
    end

    pos += 1

    return status if status != 'nil'
  end
end

def part1(data)
  c = []

  data.each_with_index do |pair, i|
    a, b = pair

    a = [a] if !list?(a)
    b = [b] if !list?(b)

    c << (i + 1) if valid?(a, b) == 'true'
  end

  c.sum
end

tb = nil

def part2(data)
  packs = data.reduce { |s, pair| s + pair }

  packs << [[2]]
  packs << [[6]]

  packs.sort! do |a, b|
    status = valid?(a, b)
    if status == 'true'
      -1
    elsif status == 'false'
      1
    else
      0
    end
  end

  c = []

  packs.each_with_index do |p, i|
    if p == [[2]]
      c << i + 1
    end
    if p == [[6]]
      c << i + 1
    end
  end

  c.reduce { |s, x| s * x }
end

puts 'part 1'

ans = part1(test_input)

puts ans

res = aoc.run(1, ta, ans) do |data|
  part1(input)
end

aoc.download if res && tb.nil?

puts 'part 2'

ans = part2(test_input)

puts ans

aoc.run(2, 140, ans) do |data|
  part2(input)
end

puts 'done'
