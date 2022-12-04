#!/usr/bin/env ruby

def load_data(file)
  File.read("#{__dir__}/#{file}").lines.map(&:strip).map { |l| l.split(',') }
      .map { |a, b| [a.split('-').map(&:to_i).sort, b.split('-').map(&:to_i).sort] }
end

def test_data
  load_data('test_input.txt')
end

def data
  load_data('input.txt')
end

def part1(data)
  data.select do |r1, r2|
    (r2[0] >= r1[0] && r2[1] <= r1[1]) || (r1[0] >= r2[0] && r1[1] <= r2[1])
  end.count
end

def part2(data)
  data.reject do |r1, r2|
    r1[0] > r2[1] || r2[0] > r1[1]
  end.count
end

puts '' * 16

puts part1(test_data)
puts part2(test_data)

puts '*' * 16

puts part1(data)
puts part2(data)
