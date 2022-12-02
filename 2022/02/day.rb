#!/usr/bin/env ruby

def test_data
  File.read('./test_input.txt').lines.map(&:strip)
end

def data
  File.read('./input.txt').lines.map(&:strip)
end

def part1(data)
  rounds = data.map(&:split)

  strategy = {
    'A' => {
      'X' => 1 + 3,
      'Y' => 2 + 6,
      'Z' => 3 + 6
    },
    'B' => {
      'X' => 1 + 0,
      'Y' => 2 + 3,
      'Z' => 3 + 6
    },
    'C' => {
      'X' => 1 + 6,
      'Y' => 2 + 0,
      'Z' => 3 + 3
    }
  }

  rounds.sum { |o, y| strategy[o][y] }
end

def part2(data)
  rounds = data.map(&:split)

  strategy = {
    'A' => {
      'X' => 3 + 0,
      'Y' => 1 + 3,
      'Z' => 2 + 6
    },
    'B' => {
      'X' => 1 + 0,
      'Y' => 2 + 3,
      'Z' => 3 + 6
    },
    'C' => {
      'X' => 2 + 0,
      'Y' => 3 + 3,
      'Z' => 1 + 6
    }
  }

  rounds.sum { |o, y| strategy[o][y] }
end

puts part1(test_data)
puts part2(test_data)

puts '*' * 16

puts part1(data)
puts part2(data)
