#!/usr/bin/env ruby

def test_data
  File.read('./test_input.txt').lines.map(&:strip)
end

def data
  File.read('./input.txt').lines.map(&:strip)
end

def part1(data)
  rounds = data.map(&:split)

  score = 0
  rounds.each do |o, y|
    if o == 'A' # rock
      if y == 'X' # rock
        score += 1 + 3
      elsif y == 'Y' # paper
        score += 2 + 6
      else # scissors
        score += 3 + 0
      end
    elsif o == 'B' # paper
      if y == 'X' # rock
        score += 1 + 0
      elsif y == 'Y' # paper
        score += 2 + 3
      else # scissors
        score += 3 + 6
      end
    else # C - scissors
      if y == 'X' # rock
        score += 1 + 6
      elsif y == 'Y' # paper
        score += 2 + 0
      else # scissors
        score += 3 + 3
      end
    end
  end

  score
end

def part2(data)
  rounds = data.map(&:split)

  score = 0
  rounds.each do |o, y|
    if o == 'A' # rock
      if y == 'X' # lose
        score += 3 + 0
      elsif y == 'Y' # draw
        score += 1 + 3
      else # win
        score += 2 + 6
      end
    elsif o == 'B' # paper
      if y == 'X' # lose
        score += 1 + 0
      elsif y == 'Y' # draw
        score += 2 + 3
      else # win
        score += 3 + 6
      end
    else # C - scissors
      if y == 'X' # lose
        score += 2 + 0
      elsif y == 'Y'
        score += 3 + 3
      else #
        score += 1 + 6
      end
    end
  end

  score
end

puts part1(test_data)
puts part2(test_data)

puts '*' * 16

puts part1(data)
puts part2(data)
