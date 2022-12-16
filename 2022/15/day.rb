#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def distance(sensor, bea)
  (sensor[0] - bea[0]).abs + (sensor[1] - bea[1]).abs
end

def part1(data, y)
  sb = []

  op = {}

  data.each do |line|
    line = line.gsub(/[^0-9:,-]/, '')
    #    puts line

    s, b = line.split(':')

    sensor = s.split(',').map(&:to_i)
    bea = b.split(',').map(&:to_i)

    dist = distance(sensor, bea)

    op[sensor] = true
    op[bea] = true
    sb << { s: sensor, b: bea, d: dist }
  end

  pr = []

  sb.each do |cfg|
    sensor = cfg[:s]

    p = [sensor.first, y]

    shortest = distance(p, sensor)

    next if shortest > cfg[:d]

    pr << ((sensor.first - (cfg[:d] - shortest))..(sensor.first + cfg[:d] - shortest))
  end

  count = {}

  pr.each do |range|
    range.each do |x|
      count[[x, y]] = 1 if op[[x, y]].nil?
    end
  end

  count.size
end

def merge_ranges(rs)
  rs = rs.sort_by { |r| [r.first, r.last] }

  (1...rs.size).each do |i|
    next if rs[i - 1].last < rs[i].first

    s = rs[i - 1].first
    e = [rs[i - 1].last, rs[i].last].max
    rs[i - 1] = nil
    rs[i] = s..e
  end

  rs.reject { |r| r.nil? }
end

def part2(data, bound)
  sb = []

  op = {}

  data.each do |line|
    line = line.gsub(/[^0-9:,-]/, '')

    s, b = line.split(':')

    sensor = s.split(',').map(&:to_i)
    bea = b.split(',').map(&:to_i)

    dist = distance(sensor, bea)

    op[sensor] = true
    op[bea] = true
    sb << { s: sensor, b: bea, d: dist }
  end

  blocked = {}

  sb.each do |cfg|
    s, b, d = cfg[:s], cfg[:b], cfg[:d]

    blocked[s[0]] = [] if blocked[s[0]].nil?
    blocked[s[0]] << ((s[1] - d)..(s[1] + d)) # middle

    # puts "sensor #{s} #{d} x=#{s[0]} #{blocked[s[0]].last}" #
    # to left
    d.times do |i|
      x = s[0] - i - 1
      next if x < 0 || x > bound

      o = d - i - 1
      blocked[x] = [] if blocked[x].nil?

      blocked[x] << ((s[1] - o)..(s[1] + o))

      # puts "left #{s} #{d} x=#{x} #{blocked[x].last}"
    end

    # to right
    d.times do |i|
      x = s[0] + i + 1
      next if x < 0 || x > bound

      o = d - i - 1
      blocked[x] = [] if blocked[x].nil?
      blocked[x] << ((s[1] - o)..(s[1] + o))

      # puts "right #{s} #{d} x=#{x} #{blocked[x].last}"
    end
  end

  beacons = {}

  sb.each do |c|
    beacons[c[:b]] = true
  end

  blocked.each do |x, rs|
    blocked[x] = merge_ranges(rs)
  end

  # puts blocked.to_s

  # exit

  bound.times do |x|
    rs = blocked[x]

    next if rs.size == 1 && rs.first.first <= 0 && rs.first.last >= bound

    bound.times do |y|
      next if rs.any? { |r| r.include?(y) } || beacons[[x, y]]
      puts "#{[x, y]}"
      return x * 4000000 + y
    end
  end
end

puts 'part 1'

ta = 26

ans = part1(aoc.test_data, 10)

# puts ans

res = aoc.run(1, ta, ans) do |data|
  part1(aoc.data, 2000000)
end

tb = 56000011

aoc.download if res && tb.nil?

puts 'part 2'

ans = part2(aoc.test_data, 20)

puts ans

aoc.run(2, tb, ans) do |data|
  part2(data, 4_000_000)
end

puts 'done'
