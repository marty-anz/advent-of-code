#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def parse_input(data)
  vals = Hash[
    data.each_with_index.map do |line, j|
      v = line[6..7]
      rate, tail = line.split('=').last.split(';')
      rate = rate.to_i
      children = tail[23..].split(',').map(&:strip)

      [v, { index: j, v: v, rate: rate, children: children }]
    end
  ]

  vals.each do |_, s|
    mask = ['0'] * vals.size

    mask[s[:index]] = '1'
    s[:bitmask] = mask.join.to_i(2)
  end

  vals
end

def release(cur, vals, min, expected, opened, rate, prev, cached)
  key = [cur[:v], opened, min]

  # puts key

  return cached[key] if cached[key]
  if opened == expected
    # paths << "#{cur[:v]} #{opened.keys.join} #{rate} #{min}"
    return cached[key] = rate * min
  end

  if min < 2
    # paths << "#{cur[:v]} #{opened.keys.join} #{rate} #{min}"
    return cached[key] = rate * min
  end

  max = 0

  # path = ''

  # subpaths = []
  next_min = min - 1

  if (opened & cur[:bitmask] == 0) && cur[:rate] != 0
    # sb = []
    rel = release(cur,
                  vals,
                  next_min,
                  expected,
                  opened | cur[:bitmask],
                  rate + cur[:rate],
                  nil,
                  cached)

    if rel > max
      max = rel
      # path = "#{cur[:v]}-#{min}-open #{cur}"
      # subpaths = sb
    end
  end

  cur[:children].each do |nv|
    # sb = []
    if nv == prev
      # puts 'do not go back'
      next
    end

    rel = release(vals[nv], vals, next_min, expected, opened, rate,
                  cur[:v],
                  cached)
    if rel > max
      max = rel
      # path = "#{cur[:v]}-#{min}-move to #{vals[nv]}"
      # subpaths = sb
    end
  end

  # paths << path
  # paths << subpaths

  cached[key] = rate + max
end

def part1(data)
  vals = parse_input(data)

  cached = {}

  mask = ['0'] * vals.size
  vals.each { |_, c| mask[c[:index]] = '1' if c[:rate] > 0 }
  expected = mask.join.to_i(2)

  opened = 0

  ans = release(vals['AA'],
                vals, 30, expected, opened, 0, nil, cached)

  puts "cached size: #{cached.size}"

  ans
end

def release2(cur, cur1, vals, min, expected, opened, released, rate, cached, prev, prev1)
  puts [cur[:v], cur1[:v], min, sprintf("%0#{vals.size}b", opened), released, rate, prev, prev1].to_s
  key = [[cur[:v], cur1[:v]].sort, opened, min]

  return cached[key] if cached[key]

  return cached[key] = rate * min if opened == expected

  # prune_key = "#{curs}-#{min}"

  released += rate

  if min < 2
    return cached[key] = rate * min
  end

  human_open = opened & cur[:bitmask] == 0 && cur[:rate] != 0
  ele_open = opened & cur1[:bitmask] == 0 && cur1[:rate] != 0

  max = 0

  next_min = min - 1

  if human_open && ele_open
    rel = release2(cur, cur1, vals, next_min, expected,
                   opened | cur[:bitmask] | cur1[:bitmask],
                   released,
                   rate + cur[:rate] + cur1[:rate],
                   cached,
                   nil, nil)

    max = rel if rel > max
  end

  if human_open
    cur1[:children].each do |nv|
      next if cur[:v] == nv || nv == prev1

      rel = release2(cur, vals[nv], vals, next_min,
                     expected, opened | cur[:bitmask],
                     released,
                     rate + cur[:rate],
                     cached,
                     nil, cur1[:v])
      max = rel if rel > max
    end
  end

  if ele_open
    cur[:children].each do |nv|
      next if nv == cur1[:v] || nv == prev

      rel = release2(vals[nv], cur1,
                     vals, next_min, expected, opened | cur1[:bitmask],
                     released,
                     rate + cur1[:rate],
                     cached,
                     cur[:v], nil)

      max = rel if rel > max
    end
  end

  cur[:children].each do |hv|
    next if hv == prev

    cur1[:children].each do |ev|
      next if hv == ev || ev == prev1

      rel = release2(vals[hv], vals[ev],
                     vals, next_min, expected, opened,
                     released,
                     rate,
                     cached,
                     cur[:v], cur1[:v])

      max = rel if rel > max
    end
  end

  cached[key] = rate + max
end

def part2(data)
  vals = parse_input(data)

  cached = {}

  mask = ['0'] * vals.size
  vals.each { |_, c| mask[c[:index]] = '1' if c[:rate] > 0 }
  expected = mask.join.to_i(2)

  opened = 0

  ans = release2(vals['AA'], vals['AA'], vals,
                 26, expected, opened,
                 0, 0,
                 cached, nil, nil)

  puts "cached size: #{cached.size}"

  ans
end

puts 'part 1'

ta = 1651

# ans = part1(aoc.test_data)

# puts ans

# aoc.run(1, ta, ans) do |data|
#   part1(aoc.data)
# end

# exit

tb = 1707

# aoc.download if res && tb.nil?

puts 'part 2'

ans = part2(aoc.test_data)
puts ans
exit

aoc.run(2, tb, ans) do |data|
  part2(data)
end

puts 'done'
