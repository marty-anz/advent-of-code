#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/sequence' # S

ROW, COL = 0, 1

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def cal(item, a, op, b)
  a = a == 'old' ? item : a.to_i
  b = b == 'old' ? item : b.to_i

  if op == '*'
    a * b
  else
    a + b
  end
end

def part1(data)
  cfg = []

  i = nil
  data.each do |line|
    if line.chars.first == 'M'
      _, i = line.split
      i = i.to_i

      cfg[i] = {}
      next
    end

    if line.chars.first == 'S'
      _, items = line.split(':')
      cfg[i][:items] = items.split(',').map(&:strip).map(&:to_i)
      next
    end

    if line.chars.first == 'O'
      _, op = line.split('=')

      cfg[i][:op] = op.split.map(&:strip)

      next
    end

    if line.chars.first == 'T'
      cfg[i][:divisor] = line.split.last.to_i
      next
    end

    if line =~ /^If true/
      cfg[i][:t] = line.split.last.to_i
      next
    end

    if line =~ /^If false/
      cfg[i][:f] = line.split.last.to_i
      next
    end
  end

  #  puts cfg.to_s

  cfg.each do |c|
    c[:count] = 0
  end

  20.times do
    cfg.each do |m|
      next if m[:items].empty?

      m[:items].each_with_index do |item, idx|
        m[:count] += 1
        worry_level = cal(item, *m[:op])
        worry_level = worry_level / 3

        throw_to = worry_level % m[:divisor] == 0 ? m[:t] : m[:f]

        m[:items][idx] = nil
        cfg[throw_to][:items] << worry_level
      end

      m[:items] = m[:items].reject { |x| x.nil? }
    end
  end

  cfg.map { |c| c[:count] }.sort.reverse.take(2).reduce { |s, x| s * x }
end

def part2(data)
  cfg = []

  i = nil
  data.each do |line|
    if line.chars.first == 'M'
      _, i = line.split
      i = i.to_i

      cfg[i] = {}
      next
    end

    if line.chars.first == 'S'
      _, items = line.split(':')
      cfg[i][:items] = items.split(',').map(&:strip).map(&:to_i)
      next
    end

    if line.chars.first == 'O'
      _, op = line.split('=')

      cfg[i][:op] = op.split.map(&:strip)

      next
    end

    if line.chars.first == 'T'
      cfg[i][:divisor] = line.split.last.to_i
      next
    end

    if line =~ /^If true/
      cfg[i][:t] = line.split.last.to_i
      next
    end

    if line =~ /^If false/
      cfg[i][:f] = line.split.last.to_i
      next
    end
  end

  divs = cfg.map { |c| c[:divisor] }

  control = divs.reduce { |s, a| s * a }

  cfg.each { |c| c[:count] = 0 }

  10000.times do
    cfg.each do |m|
      next if m[:items].empty?

      m[:count] += m[:items].count

      m[:items].each_with_index do |item, idx|
        worry_level = cal(item, *m[:op])

        div = worry_level % m[:divisor] == 0

        throw_to = div ? m[:t] : m[:f]

        m[:items][idx] = nil

        cfg[throw_to][:items] << (worry_level % control)
      end

      m[:items] = m[:items].reject { |x| x.nil? }
    end
  end

  cfg.map { |c| c[:count] }.sort.reverse.take(2).reduce { |s, x| s * x }
end

ans = part1(aoc.test_data)

aoc.run(1, 10605, ans) do |data|
  part1(data)
end

# aoc.download if res

puts 'part 2'

ans = part2(aoc.test_data)

aoc.run(2, 2713310158, ans) do |data|
  part2(data)
end

puts 'done'
