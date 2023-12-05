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

    # target, source, range
    maps[k] << x.split(" ").map(&:to_i)
  end

  loc = seeds.map do |val|
    maps.each do |_, ranges|
      ranges.each do |target, source, range|
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

    t, s, r = x.split(" ").map(&:to_i)

    maps[k] << [[t, t+r-1], [s, s+r-1]]
  end


  unmatched = seeds.each_slice(2).map { |s, t| [s, s + t - 1] }

  # ruby's map preverse the insert order
  maps.keys.each do |step|
    matched_targets, still_unmatched = [], []

    # go through each mapping
    maps[step].each do |target, source|
      still_unmatched = []

      # for each unmatched, match against the source range for the next step
      unmatched.each do |val_start, val_end|
        source_start, source_end = source

        # no overlapping, still unmatched
        #                [...source range...]
        # [...val_end]                        p [val_start...]
        if val_start > source_end || val_end < source_start
          still_unmatched << [val_start, val_end]
          next
        end

        if val_start < source_start
          #                [...source range...]
          # [val_start....][......val_end]
          # [val_start....][..................]..val_end]

          still_unmatched << [val_start, source_start - 1]

          match = [source_start, [source_end, val_end].min]

          mapped_start = target[0]

          matched_targets << [mapped, mapped_start + match[1] - match[0]]
        else
          #                [.....source range......]
          #                [val_start...val_end]
          #                [val_start.............val_end]
          match = [[val_start, source_start].max, [source_end, val_end].min]

          mapped_start = target[0] + match[0] - source_start

          matched_targets << [mapped, mapped_start + match[1] - match[0]]
        end

        if val_end > source_end
          #                [.....source range......]
          #                [val_start..................val_end]
          still_unmatched << [source_end + 1, val_end]
        end
      end

      # try unmatched for the next mapping
      unmatched = still_unmatched
    end


    # still_unmatched are 1-1 matched to target, together matched becomes
    # unmatched for the next step
    unmatched = still_unmatched + matched
  end

  unmatched.map { |s, _| s}.min
end

ans = part2(aoc.test_data)

aoc.run(2, 46, ans) { |data| part2(data) }
