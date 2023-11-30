#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def execute(ins)
  a = 0
  pos = 0

  seen = {}

  while true
    seen[pos] = true

    i, b = ins[pos]
    pos += 1
    if i == "acc"
      a += b
    elsif i == "jmp"
      pos += b - 1
    end

    return a if pos == ins.count

    return nil if seen[pos]
  end

  return a
end

def part1(input)
  ins = input.map(&:strip).map do |l|
    i, b = l.split(" ")
    [i, b.to_i]
  end

  a = 0
  pos = 0

  seen = {}

  while true
    seen[pos] = true

    i, b = ins[pos]
    pos += 1
    if i == "acc"
      a += b
    elsif i == "jmp"
      pos += b - 1
    end

    return a if seen[pos]
  end
end

ans = part1(aoc.test_data)

res = aoc.run(1, 5, ans) do |data|
  part1(data)
end

def part2(input)
  ins = input.map(&:strip).map do |l|
    i, b = l.split(" ")
    [i, b.to_i]
  end

  (0...ins.count).each do |i|
    x, b = ins[i]

    if x == "nop"
      ins[i] = ["jmp", b]
      r = execute(ins)
      if r.nil?
        ins[i] = ["nop", b]
      else
        return r
      end
    elsif x == "jmp"
      ins[i] = ["nop", b]
      r = execute(ins)
      if r.nil?
        ins[i] = ["jmp", b]
      else
        return r
      end
    end
  end
end

ans = part2(aoc.test_data)

aoc.run(2, 8, ans) do |data|
  part2(data)
end
