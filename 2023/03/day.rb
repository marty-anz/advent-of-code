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
  ps = []
  digits.each do |_, r, c|
    ps += M.bounded_surrounding(engine, r, c)
  end

  pos = []
  ps.each do |p|
    digits.each do |_, r, c|
      pos << p if p != [r, c]
    end
  end

  pos.each do |x, y|
    return true if engine[x][y] != '.' && engine[x][y] !~ /\d/
  end

  false
end

def part1(input)
  parts = []

  engine = input.map(&:chars)

  digits = []
  is_number = false

  engine.each_with_index do |row, r|
    row.each_with_index do |x, c|
      if x =~ /\d/
        is_number = true
        digits << [x, r, c]
      else
        if is_number
          if check_valid(input, digits)
            parts << digits.map { |d| d.first }.join.to_i
          end

          is_number = false
          digits = []
        end
      end
    end

    if is_number
      if check_valid(input, digits)
        parts << digits.map { |d| d.first }.join.to_i
      end

      is_number = false
      digits = []
    end
  end

  parts.sum
end

ans = part1(aoc.test_data)

aoc.run(1, 4361, ans) { |data| part1(data) }

def find_numbers()
end
def part2(input)
  parts = []

  engine = input.map(&:chars)

  digits = []
  is_number = false

  engine.each_with_index do |row, r|
    row.each_with_index do |x, c|
      if x =~ /\d/
        is_number = true
        digits << [x, r, c]
      else
        if is_number
          n = digits.map { |d| d.first }.join.to_i
          parts << [n, digits]

          is_number = false
          digits = []
        end
      end
    end

    if is_number
      n = digits.map { |d| d.first }.join.to_i
      parts << [n, digits]

      is_number = false
      digits = []
    end
  end

  pos_to_n = {}

  parts.each do |n, m|
    m.each { |_, x, y| pos_to_n[[x,y]] = n }
  end

  ratio = []

  engine.each_with_index do |row, r|
    row.each_with_index do |x, c|
      next if x != '*'

      pos = M.bounded_surrounding(engine, r, c)

      digs = []
      pos.each do |m, n|
        digs << pos_to_n[[m, n]] if engine[m][n] =~ /\d/
      end

      digs = digs.uniq

      ratio << digs[0] * digs[1] if digs.count == 2
    end
  end

  ratio.sum
end


ans = part2(aoc.test_data)

aoc.run(2, 467835, ans) { |data| part2(data) }
