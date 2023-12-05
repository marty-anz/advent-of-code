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
  seeds = input.shift.split("seeds: ")[1].split(" ").map(&:to_i)

  k = ""

  maps = {}

  input.each do |x|
    x = x.strip
    next if x == ""

    if x =~ /map:/
      k = x.split(" ")[0]
      maps[k] = []
      next
    end

    r = x.split(" ").map(&:to_i)

    maps[k] << [r[0], r[1], r[2]]

    # r[2].times do |i|
    #   maps[k][r[1]+i] = r[0] + i
    # end
  end

  loc = seeds.map do |val|
    ['seed-to-soil', 'soil-to-fertilizer','fertilizer-to-water','water-to-light',
     'light-to-temperature','temperature-to-humidity','humidity-to-location'].each do |k|
      maps[k].each do |target, source, range|
        if val >= source && val <= source + range
          val = target + val - source
          break
        end
      end
    end
    val
  end

  loc.min
end

ans = part1(aoc.test_data)

aoc.run(1, 35, ans) { |data| part1(data) }

def part2(input)
  seeds = input.shift.split("seeds: ")[1].split(" ").map(&:to_i)

  maps = {}

  k = ""
  input.each do |x|
    x = x.strip
    next if x == ""

    if x =~ /map:/
      k = x.split(" ")[0]
      maps[k] = []
      next
    end

    r = x.split(" ").map(&:to_i)

    maps[k] << [[r[0], r[0] + r[2] -1], [r[1], r[1] + r[2] - 1]]
  end


  ranges = seeds.each_slice(2).map do |s, t|
    [s, s + t - 1]
  end

  unmatched = ranges
  matched = []

  ['seed-to-soil', 'soil-to-fertilizer','fertilizer-to-water','water-to-light',
   'light-to-temperature','temperature-to-humidity','humidity-to-location'].each do |step|
    matched = []
    still_unmatched = []

    maps[step].each do |target, source|
      still_unmatched = []

      unmatched.each do |val_start, val_end|
        source_start, source_end = source

        if val_start > source_end || val_end < source_start
          still_unmatched << [val_start, val_end]
          next
        end

        if val_start < source_start
          still_unmatched << [val_start, source_start - 1]
          match = [source_start, [source_end, val_end].min]

          matched << [target[0], target[0] + match[1] - match[0]]
        else
          match = [[val_start, source_start].max, [source_end, val_end].min]

          x =[target[0] + match[0] - source_start, target[0] + match[0] - source_start + match[1] - match[0]]

          matched << x 
        end

        if val_end > source_end
          still_unmatched << [source_end + 1, val_end]
        end
      end

      unmatched = still_unmatched + []
    end


    unmatched = still_unmatched + matched
  end


  unmatched.map { |s, _| s}.min
end

ans = part2(aoc.test_data)

aoc.run(2, 46, ans) { |data| part2(data) }
