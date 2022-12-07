#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/sequence' # S

aoc = Aoc.new(__dir__) do |data|
  data
end

ta = 95437

def cal_total(dir, found)
  dir[:total_size] = dir[:size]
  if dir[:sub].empty?
    found << dir[:total_size]
    return dir[:total_size]
  end

  dir[:total_size] += dir[:sub].values.sum do |sub|
    cal_total(sub, found)
  end

  found << dir[:total_size]
  return dir[:total_size]
end

def part1(data)
  root = { sub: {}, size: 0, parent: nil }

  curdir = root

  data.shift

  data.each do |e|
    if e[0] == '$'
      cmd, dir = e.split[1..]

      next if cmd == 'ls'

      if dir == '..'
        curdir = curdir[:parent]
      else
        curdir[:sub][dir] ||= { sub: {}, size: 0, parent: curdir }

        curdir = curdir[:sub][dir]
      end
    else
      a = e.split.first
      curdir[:size] += a.to_i if a =~ /^\d/
    end
  end

  found = []
  cal_total(root, found)

  found.select { |x| x <= 100000 }.sum
end

tb = 24933642

def part2(data)
  root = { sub: {}, size: 0, parent: nil }

  curdir = root

  data.shift

  data.each do |e|
    if e[0] == '$'
      cmd, dir = e.split[1..]

      next if cmd == 'ls'

      if dir == '..'
        curdir = curdir[:parent]
      else
        curdir[:sub][dir] ||= { sub: {}, size: 0, parent: curdir }

        curdir = curdir[:sub][dir]
      end
    else
      a = e.split.first
      curdir[:size] += a.to_i if a =~ /^\d/
    end
  end

  found = []
  cal_total(root, found)

  unused = 70000000 - root[:total_size]
  found.select do |s|
    unused + s >= 30000000
  end.sort.first
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
