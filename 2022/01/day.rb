#!/usr/bin/env ruby

def test_data
  File.read('./test_input.txt').lines.map { |l| l.strip.to_i }
end

def data
  File.read('./input.txt').lines.map { |l| l.strip.to_i }
end

def part1(data)
  cals = [0]
  i = 0

  data.each do |cal|
    if cal.zero?
      i += 1
      cals[i] = 0
    else
      cals[i] += cal
    end
  end

  cals.max
end

def part2(data)
  cals = [0]
  i = 0

  data.each do |cal|
    if cal.zero?
      i += 1
      cals[i] = 0
    else
      cals[i] += cal
    end
  end

  cals.sort.reverse[0..2].sum
end

puts part1 test_data
puts part2 test_data

puts '*' * 8

puts part1 data
puts part2 data
