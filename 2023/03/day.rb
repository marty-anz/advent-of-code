#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def check_valid(engine, digits)
  digits.each do |_, r, c|
    M.bounded_surrounding(engine, r, c).each do |x, y|
      return true if engine[x][y] != '.' && engine[x][y] !~ /\d/
    end
  end

  false
end

def part1(input)
  parts = []

  engine = input.map(&:chars)

  digits = []
  in_number = false

  engine.each_with_index do |row, r|
    row.each_with_index do |x, c|
      if x =~ /\d/
        in_number = true
        digits << [x, r, c]
      else
        if in_number
          if check_valid(input, digits)
            parts << digits.map { |d| d.first }.join.to_i
          end

          in_number = false
          digits = []
        end
      end
    end

    if in_number
      if check_valid(input, digits)
        parts << digits.map { |d| d.first }.join.to_i
      end

      in_number = false
      digits = []
    end
  end

  parts.sum
end

ans = part1(aoc.test_data)

aoc.run(1, 4361, ans) { |data| part1(data) }

def part2(input)
  engine = input.map(&:chars)

  pos_to_n = {}

  digits = []
  in_number = false

  engine.each_with_index do |row, r|
    row.each_with_index do |x, c|
      if x =~ /\d/
        in_number = true
        digits << [x, r, c]
      else
        if in_number
          n = digits.map { |d| d.first }.join.to_i
          digits.each { |_, s, t| pos_to_n[[s, t]] = n }

          in_number = false
          digits = []
        end
      end
    end

    if in_number
      n = digits.map { |d| d.first }.join.to_i
      digits.each { |_, s, t| pos_to_n[[s, t]] = n }
    end

    in_number = false
    digits = []
  end

  ratio = []

  engine.each_with_index do |row, r|
    row.each_with_index.select { |x, _| x == '*' }.each do |_, c|
      pos = M.bounded_surrounding(engine, r, c)

      digs = []
      pos.each do |m, n|
        digs << pos_to_n[[m, n]] if engine[m][n] =~ /\d/
      end

      digs.uniq!

      ratio << digs[0] * digs[1] if digs.count == 2
    end
  end

  ratio.sum
end

ans = part2(aoc.test_data)

aoc.run(2, 467835, ans) { |data| part2(data) }
