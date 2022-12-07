#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/sequence' # S

aoc = Aoc.new(__dir__) do |data|
  data
end

ta = 95437

def total(dir, dirs)
  stats = dirs[dir]

  return stats[:size] if stats[:sub].empty?

  stats[:sub].sum do |sub|
    total(sub, dirs)
  end + stats[:size]
end

def part1(data)
  # 42805968
  # 29463726

  curdir = { path: '/', sub: [], size: 0, parent: nil }
  dirs = { '/' => curdir }

  data.shift

  data.each do |e|
    if e[0] == '$'
      cmd, dir = e.split[1..]

      next if cmd == 'ls'

      if dir == '..'
        curdir = dirs[curdir[:parent]]
        next
      end

      path = curdir[:path] + '/' + dir
      curdir = dirs[path] || { path: path, sub: [], size: 0, parent: curdir[:path] }
      dirs[path] = curdir
    else
      a, b = e.split

      if a == 'dir'
        curdir[:sub] << (curdir[:path] + '/' + b)
      else
        curdir[:size] += a.to_i
      end
    end
  end

  dirs.keys.map do |d|
    t = total(d, dirs)
    dirs[d][:total_size] = t
  end.select { |x| x <= 100000 }.sum
end

tb = 24933642

def part2(data)
  # 42805968
  # 29463726

  curdir = { path: '/', sub: [], size: 0, parent: nil }
  dirs = { '/' => curdir }

  data.shift

  data.each do |e|
    if e[0] == '$'
      cmd, dir = e.split[1..]

      next if cmd == 'ls'

      if dir == '..'
        curdir = dirs[curdir[:parent]]
      else
        path = curdir[:path] + '/' + dir
        curdir = dirs[path] || { path: path, sub: [], size: 0, parent: curdir[:path] }
        dirs[path] = curdir
      end
    else
      a, b = e.split

      if a == 'dir'
        curdir[:sub] << (curdir[:path] + '/' + b)
      else
        curdir[:size] += a.to_i
      end
    end
  end

  dirs.keys.each do |d|
    t = total(d, dirs)
    dirs[d][:total_size] = t
  end

  # 70000000
  # 30000000
  used = dirs['/'][:total_size]

  x = dirs.keys.map do |p|
    [p, dirs[p][:total_size]]
  end.select do |_, s|
    70000000 - used + s >= 30000000
  end.sort_by do |_, s|
    s
  end

  x[0][1]
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
