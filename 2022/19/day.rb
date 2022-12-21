#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

puts 'part 1'

def parse_blueprint(line)
  [
    line.match(/Each ore robot costs (\d+) ore./).captures.map(&:to_i),
    line.match(/Each clay robot costs (\d+) ore./).captures.map(&:to_i),
    line.match(/Each obsidian robot costs (\d+) ore and (\d+) clay./).captures.map(&:to_i),
    line.match(/Each geode robot costs (\d+) ore and (\d+) obsidian./).captures.map(&:to_i)
  ]
end

def can_make_geode?(bp, ore, ob)
  ore >= bp[3][0] && ob >= bp[3][1]
end

def can_make_ob?(bp, ore, clay)
  ore >= bp[2][0] && clay >= bp[2][1]
end

def can_make_clay?(bp, ore)
  ore >= bp[1][0]
end

def can_make_ore?(bp, ore)
  ore >= bp[0][0]
end

def run_bp(bp, bots, res, min, cached, prune, results)
  if min == 0
    results << res
    return
  end

  cache_key = "#{bots.join('-')}.#{res.join('-')}.#{min}"

  if cached[cache_key]
    return
  else
    cached[cache_key] = true
  end

  if prune[min].nil?
    prune[min] = {}

    prune[min][:bots] = bots.clone
    prune[min][:res] = res.clone
  else
    if (prune[min][:res][3] + prune[min][:bots][3] * min) > (bots[3] * min + res[3])
      # puts "#{min} #{prune[min][:res][3]} #{prune[min][:bots][3]} > #{bots[3]} #{res[3]}"
      return
    else
      prune[min][:bots][3] = bots[3]
      prune[min][:res][3] = res[3]
    end
  end

  make_geode = can_make_geode?(bp, res[0], res[2])

  if make_geode
    new_bots = bots.clone
    new_bots[3] += 1
    new_res = res.clone

    new_res[0] += bots[0]
    new_res[1] += bots[1]
    new_res[2] += bots[2]
    new_res[3] += bots[3]

    new_res[0] -= bp[3][0]
    new_res[2] -= bp[3][1]

    run_bp(bp, new_bots, new_res, min - 1, cached, prune, results)
  end

  make_ob = can_make_ob?(bp, res[0], res[1])

  if make_ob
    new_bots = bots.clone
    new_bots[2] += 1
    new_res = res.clone

    new_res[0] += bots[0]
    new_res[1] += bots[1]
    new_res[2] += bots[2]
    new_res[3] += bots[3]

    new_res[0] -= bp[2][0]
    new_res[1] -= bp[2][1]

    run_bp(bp, new_bots, new_res, min - 1, cached, prune, results)
  end

  make_clay = can_make_clay?(bp, res[0])

  if can_make_clay?(bp, res[0])
    new_bots = bots.clone
    new_bots[1] += 1
    new_res = res.clone

    new_res[0] += bots[0]
    new_res[1] += bots[1]
    new_res[2] += bots[2]
    new_res[3] += bots[3]

    new_res[0] -= bp[1][0]

    run_bp(bp, new_bots, new_res, min - 1, cached, prune, results)
  end

  if can_make_ore?(bp, res[0])
    new_bots = bots.clone
    new_bots[0] += 1
    new_res = res.clone

    new_res[0] += bots[0] - bp[0][0]
    new_res[1] += bots[1]
    new_res[2] += bots[2]
    new_res[3] += bots[3]

    run_bp(bp, new_bots, new_res, min - 1, cached, prune, results)
  end

  # try this if not make geode

  new_bots = bots.clone
  new_res = res.clone

  new_res[0] += bots[0]
  new_res[1] += bots[1]
  new_res[2] += bots[2]
  new_res[3] += bots[3]

  run_bp(bp, new_bots, new_res, min - 1, cached, prune, results)
end

def run_bp_loop(bp, bots, res, min)
  ctx = [[bots, res, min]]
  cached = {}

  result = nil

  while !ctx.empty?
    bots, res, min = ctx.shift

    if min == 0
      result = res if result[3] < res[3]

      next
    end

    cache_key = "#{bots.join('-')}.#{res.join('-')}.#{min}"

    if cached[cache_key]
      next
    else
      cached[cache_key] = true
    end

    # evaluate different scenarios
    make_geode = can_make_geode?(bp, res[0], res[2])

    if make_geode
      new_bots = bots.clone
      new_bots[3] += 1
      new_res = res.clone

      new_res[0] += bots[0]
      new_res[1] += bots[1]
      new_res[2] += bots[2]
      new_res[3] += bots[3]

      new_res[0] -= bp[3][0]
      new_res[2] -= bp[3][1]

      ctx << [new_bots, new_res, min - 1]
    end

    make_ob = can_make_ob?(bp, res[0], res[1])

    if make_ob
      new_bots = bots.clone
      new_bots[2] += 1
      new_res = res.clone

      new_res[0] += bots[0]
      new_res[1] += bots[1]
      new_res[2] += bots[2]
      new_res[3] += bots[3]

      new_res[0] -= bp[2][0]
      new_res[1] -= bp[2][1]

      ctx << [new_bots, new_res, min - 1]
    end

    if can_make_clay?(bp, res[0])
      new_bots = bots.clone
      new_bots[1] += 1
      new_res = res.clone

      new_res[0] += bots[0]
      new_res[1] += bots[1]
      new_res[2] += bots[2]
      new_res[3] += bots[3]

      new_res[0] -= bp[1][0]

      ctx << [new_bots, new_res, min - 1]
    end

    if can_make_ore?(bp, res[0])
      new_bots = bots.clone
      new_bots[0] += 1
      new_res = res.clone

      new_res[0] += bots[0] - bp[0][0]
      new_res[1] += bots[1]
      new_res[2] += bots[2]
      new_res[3] += bots[3]

      ctx << [new_bots, new_res, min - 1]
    end

    new_bots = bots.clone
    new_res = res.clone

    new_res[0] += bots[0]
    new_res[1] += bots[1]
    new_res[2] += bots[2]
    new_res[3] += bots[3]

    ctx << [new_bots, new_res, min - 1]
  end

  result
end

def part1(data)
  blueprints = data.map do |line|
    parse_blueprint(line)
  end

  puts blueprints[0].to_s
  puts blueprints[1].to_s

  blueprints.take(1).each_with_index.map do |bp, i|
    bots = [1, 0, 0, 0]
    res = [0, 0, 0, 0]
    cached = {}

    results = []
    prune = []

    #  run_bp(bp, bots, res, 32, cached, prune, results)
    #
    result = run_bp_loop(bp, bots, res, 24)

    g = result[3]
    # g = results.map { |r| r.last }.max

    puts "#{i + 1} #{g}"
    g * (i + 1)

    return
  end.sum
end

def part2(data)
  blueprints = data.map do |line|
    parse_blueprint(line)
  end

  # puts blueprints[0].to_s
  # puts blueprints[1].to_s

  gs = blueprints.take(3).each_with_index.map do |bp, i|
    bots = [1, 0, 0, 0]
    res = [0, 0, 0, 0]
    cached = {}

    results = []
    prune = []

    # run_bp(bp, bots, res, 32, cached, prune, results)

    result = run_bp_loop(bp, bots, res, 24)
    # g = results.map { |r| r.last }.max

    g = result[3]
    puts "#{i + 1} #{g}"

    g
  end

  gs.reduce { |p, s| p * s }
end

ta = 33

ans = part1(aoc.test_data)

puts ans

exit

res = aoc.run(1, ta, ans) do |data|
  part1(aoc.data)
end

#exit

tb = nil

puts 'part 2'

ans = part2(aoc.test_data)

puts ans

puts part2(aoc.data)

aoc.run(2, tb, ans) do |data|
  part2(data)
end

puts 'done'
