#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def check(parts)
  parts.each do |part|
    counts = {"blue" => 0, "red" => 0, "green" => 0}

    part.split(", ").each do |pair|
      c, color = pair.split(" ")
      counts[color] += c.to_i
    end

    return false unless counts["red"] <= 12 && counts["green"] <= 13 && counts["blue"] <= 14
  end

  true
end

def part1(input)
  possible = []

  input.map do |x|
    g, bags = x.split(":")
    id = g.sub("Game ", "").to_i
    parts = bags.split("; ")

    possible << id if check(parts)
  end

  possible.sum
end

ans = part1(aoc.test_data)

aoc.run(1, 8, ans) { |data| part1(data) }

def part2(input)
  input.map do |x|
    g, bags = x.split(":")
    parts = bags.split("; ")

    counts = {"blue" => 0, "red" => 0, "green" => 0}

    parts.each do |part|
      part.split(", ").each do |pair|
        c, color = pair.split(" ")
        counts[color] = c.to_i if counts[color] == 0 || counts[color] < c.to_i
      end
    end

    counts.values.inject(:*)
  end.sum
end

ans = part2(aoc.test_data)

aoc.run(2, 2286, ans) { |data| part2(data) }
