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
    s = x.gsub(/[a-z]/, "")

    "#{s[0]}#{s[-1]}".to_i
  end.sum
end

ans = part1(aoc.test_data)

aoc.run(1, 142, ans) do |data|
  part1(data)
end

def part2(input)
  numbers = {
    'one' => 1, 'two' => 2, 'three' => 3, 'four' => 4, 'five' => 5, 'six' => 6, 'seven' => 7, 'eight' => 8, 'nine' => 9,
    '1' => 1, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9,
  }

  input.map do |x|
    first, last = nil, nil
    fn, ln = nil, nil

    numbers.each do |word, n|
      f, l = x.index(word), x.rindex(word)

      first, fn = f, n if !f.nil? && (first.nil? || f < first)

      last, ln = l, n if !l.nil? && (last.nil? || l > last)
    end

    "#{fn}#{ln}".to_i
  end.sum
end

ans = part2(aoc.test_data2)

aoc.run(2, 281, ans) do |data|
  part2(data)
end
