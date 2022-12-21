#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def release(cur, vals, min, expected, opened, rate, cached, paths)
  key = "#{cur[:v]}-#{opened.keys.sort.join('.')}.#{min}"

  # puts key

  return cached[key] if cached[key]

  if opened.size == expected
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
  if !opened[cur[:v]] && cur[:rate] != 0
    sb = []
    rel = release(cur, vals, next_min, expected, opened.merge({ cur[:v] => true }), rate + cur[:rate], cached, sb)

    if rel > max
      max = rel
      # path = "#{cur[:v]}-#{min}-open #{cur}"
      # subpaths = sb
    end
  end

  cur[:children].each do |nv|
    sb = []
    rel = release(vals[nv], vals, next_min, expected, opened, rate, cached, sb)
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

def find_deep_path(start, vals, depth, prev, paths)
  return if depth == 0

  vals[start][:children].reject do |v|
    prev[v]
  end.each do |v|
    paths << prev.keys + [start, v]
    find_deep_path(v, vals, depth - 1, prev.merge({ start => true }), paths)
  end
end

def weight(path, vals, length)
  size = path.size
  rate = vals[path.last][:rate]

  rate * (length - size)
end

def sort_paths(paths, vals)
  paths.sort do |a, b|
    a_rate = vals[a.last][:rate]
    b_rate = vals[b.last][:rate]

    if a.size > b.size
      a_weight = a_rate
      b_weight = b_rate * (a.size - b.size + 1)
    elsif a.size < b.size
      a_weight = a_rate * (b.size - a.size + 1)
      b_weight = b_rate
    else
      a_weight = a_rate
      b_weight = b_rate
    end

    a_weight - b_weight
  end
end

def run_recips(recips, vals, min)
  rate = 0
  released = 0

  recip = []

  while min > 0
    if recip.empty?
      recip = recips.shift
    end

    if recip.nil?
      released += rate * min
      break
    end
    v = recip.shift

    min -= 1
    released += rate

    if recip.empty?
      rate += vals[v][:rate]
    end
  end

  released
end

def part1_a(data)
  vals = {}

  data.each do |line|
    v = line[6..7]
    rate, tail = line.split('=').last.split(';')
    rate = rate.to_i
    children = tail[23..].split(',').map(&:strip)

    vals[v] = { v: v, rate: rate, children: children }
  end

  targets = vals.select { |_, c| c[:rate] > 0 }.map { |v, _| v }

  puts(targets.map do |v|
    "#{v}-#{vals[v][:rate]}"
  end.join(','))

  start = 'AA'

  paths = []

  # find_deep_path('DD', vals, 10, {}, paths)

  # paths = paths.select { |p| targets.include?(p.last) }

  # paths = sort_paths(paths, vals)

  # paths.each do |p|
  #   puts p.join(',')
  # end

  optimal = []
  while !targets.empty?
    paths = []
    find_deep_path(start, vals, 13, {}, paths)

    paths = paths.select { |p| targets.include?(p.last) }

    chosen = sort_paths(paths, vals).last

    targets = targets.select { |t| t != chosen.last }

    start = chosen.last

    optimal << chosen
  end

  # optimal
  optimal.each do |o|
    puts o.join(',')
  end

  ans = run_recips(optimal, vals, 30)

  ans
end

def remap_key(vals)
  remap = Hash[vals.keys.sort.each_with_index.map do |v, i|
                 [v, i]
               end]
  Hash[vals.map do |v, c|
         c[:children] = c[:children].map do |c|
           remap[c]
         end

         [remap[v], c]
       end]
end

def parse_input(data)
  vals = {}

  data.each do |line|
    v = line[6..7]
    rate, tail = line.split('=').last.split(';')
    rate = rate.to_i
    children = tail[23..].split(',').map(&:strip)

    vals[v] = { v: v, rate: rate, children: children }
  end

  remap_key(vals)
end

def part1(data)
  vals = parse_input(data)

  opened = {}
  cached = {}
  expected = vals.select { |_, c| c[:rate] > 0 }.count
  ans = release(vals[0],
                vals, 30, expected, opened, 0, cached, [])

  puts cached.size

  ans
end

def release2(cur, cur1, vals, min, expected, opened, released, rate, cached, prune)
  prune_key = opened.keys.sort.join

  curs = [cur[:v], cur1[:v]].sort.join
  key = [curs, '-', prune_key, '-', min].join

  if prune[key].nil?
    prune[key] = released
  else
    if prune[key] > released
      return cached[key] = 0
    else
      prune[key] = released
    end
  end

  if cached[key]
    return cached[key]
  end

  # prune_key = "#{curs}-#{min}"

  released += rate

  # if min < 13 && opened.size < 2
  #   return cached[key] = 0
  # end
  if min < 2
    return cached[key] = rate * min
  end

  if opened.size == expected
    #  puts "total (all open): #{rate} #{min} #{released} #{rate * min + released}"
    return cached[key] = rate * min
  end

  human_open = !opened[cur[:v]] && cur[:rate] != 0
  ele_open = !opened[cur1[:v]] && cur1[:rate] != 0

  max = 0

  next_min = min - 1

  if human_open && ele_open
    rel = release2(cur, cur1, vals, next_min, expected,
                   opened.merge({ cur[:v] => true, cur1[:v] => true }),
                   released,
                   rate + cur[:rate] + cur1[:rate], cached, prune)

    max = rel if rel > max
  end

  if human_open
    cur1[:children].each do |nv|
      next if cur[:v] == nv

      rel = release2(cur, vals[nv], vals, next_min,
                     expected, opened.merge({ cur[:v] => true }),
                     released,
                     rate + cur[:rate], cached, prune)
      max = rel if rel > max
    end
  end

  if ele_open
    cur[:children].each do |nv|
      next if nv == cur1[:v]

      rel = release2(vals[nv], cur1,
                     vals, next_min, expected,
                     opened.merge({ cur1[:v] => true }),
                     released,
                     rate + cur1[:rate],
                     cached, prune)

      max = rel if rel > max
    end
  end

  cur[:children].each do |hv|
    cur1[:children].each do |ev|
      next if hv == ev

      rel = release2(vals[hv], vals[ev],
                     vals, next_min, expected, opened,
                     released,
                     rate,
                     cached, prune)

      max = rel if rel > max
    end
  end

  cached[key] = rate + max
end

def find_single_path(start, vals, prev, unvisited)
  return if unvisited.empty?

  puts "visiting #{prev.map { |v| "#{v} #{vals[v][:rate]}" }}, #{start} #{vals[start][:rate]}"
  unvisited[start] = false

  vals[start][:children].select do |c|
    unvisited[c]
  end.each do |c|
    find_single_path(c, vals, prev + [start], unvisited)
  end
end

def part2(data)
  vals = {}
  max_rate = 0
  count = 0

  unvisited = {}

  data.each do |line|
    v = line[6..7]
    rate, tail = line.split('=').last.split(';')
    rate = rate.to_i
    children = tail[23..].split(',').map(&:strip)

    count += 1 if rate > 0

    unvisited[v] = true

    max_rate += rate
    vals[v] = { v: v, rate: rate, children: children }
  end

  # find_single_path('AA', vals, [], unvisited)

  # return
  puts "max_rate #{max_rate} #{count}"

  opened = {}
  cached = {}
  expected = vals.select { |_, c| c[:rate] > 0 }.count
  ans = release2(vals['AA'], vals['AA'],
                 vals, 26, expected, opened, 0, 0, cached, {})
  ans
end

puts 'part 1'

# ta = 1651

# ans = part1(aoc.test_data)

# puts ans

# res = aoc.run(1, ta, ans) do |data|
#   part1(aoc.data)
# end

# exit

tb = 1707

# aoc.download if res && tb.nil?

puts 'part 2'

ans = part2(aoc.test_data)

puts ans

puts 'xxxxx '
puts part2(aoc.data)

exit

aoc.run(2, tb, 1707) do |data|
  part2(data)
end

puts 'done'
