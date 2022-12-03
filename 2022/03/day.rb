#!/usr/bin/env ruby

def test_data
  File.read('./test_input.txt').lines.map(&:strip)
end

def data
  File.read('./input.txt').lines.map(&:strip)
end

def part1(data)
  data.sum do |line|
    sz = line.size / 2
    l = [line[0..(sz - 1)], line[sz..]].map(&:chars).reduce { |s, x| s & x }.pop
    l >= 'a' ? l.ord - 'a'.ord + 1 : l.ord - 'A'.ord + 27
  end
end

def part2(data)
  (data.count / 3).times.sum do |g|
    i = g * 3
    l = data[i..(i + 2)].map(&:chars).reduce { |s, x| s & x }.pop
    l >= 'a' ? l.ord - 'a'.ord + 1 : l.ord - 'A'.ord + 27
  end
end

puts part1(test_data)
puts part2(test_data)

puts '*' * 16

puts part1(data)
puts part2(data)
