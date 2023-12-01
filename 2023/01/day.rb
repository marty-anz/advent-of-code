#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def part1(input)
  input.map do |x|
    s = x.gsub(/[^\d]/, "")
    "#{s[0]}#{s[-1]}".to_i
  end.sum
end

ans = part1(aoc.test_data)

aoc.run(1, 142, ans) do |data|
  part1(data)
end

def part2(input)
  input.map do |x|
    while true
      m = /(one|two|three|four|five|six|seven|eight|nine)/.match(x)

      break if m.nil?

      if m[0] == 'one'
        n = "1e"
      elsif m[0] == 'two'
        n = "2o"
      elsif m[0] == 'three'
        n = "3e"
      elsif m[0] == 'four'
        n = "4r"
      elsif m[0] == 'five'
        n = "5e"
      elsif m[0] == 'six'
        n = "6x"
      elsif m[0] == 'seven'
        n = "7n"
      elsif m[0] == 'eight'
        n = "8t"
      elsif m[0] == 'nine'
        n = "9e"
      end

      x = x.sub(m[0], n)
    end

    s = x.gsub(/[^\d]/, "")

    "#{s[0]}#{s[-1]}".to_i
  end.sum
end

ans = part2(aoc.test_data)

aoc.run(2, 281, ans) do |data|
  part2(data)
end
