#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'
require '../../lib/deq'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip).map(&:to_i)
end

def part1(data)
  deq = Deq.new(data)

  deq.nodes.each do |node|
    next if node.value == 0

    deq.current = node

    _, left, right = deq.remove_current

    deq.current = node.value > 0 ? right : left

    if node.value > 0
      deq.move_right(node.value - 1)
      deq.insert_right(node)
    else
      deq.move_left(node.value.abs - 1)
      deq.insert_left(node)
    end
  end

  lst = deq.to_right_list.map(&:value)

  offset = lst.find_index { |n| n == 0 }

  cor = lst[offset..] + lst[0...offset]

  x, y, z = (1000) % deq.size, (2000) % deq.size, (3000) % deq.size

  puts [cor[x], cor[y], cor[z]].to_s

  [cor[x], cor[y], cor[z]].sum
end

ta = 3

ans = part1(aoc.test_data)

puts ans

puts part1(aoc.data)

res = aoc.run(1, ta, ans) do |data|
  part1(data)
end

tb = nil?

aoc.download if res && tb.nil?

def part2(data)
  key = 811589153
  data = data.map { |x| x * key }

  deq = Deq.new(data)

  # puts "intial #{deq.to_right_list.map(&:value)} #{deq.to_left_list.map(&:value)}"

  10.times do
    deq.nodes.each do |node|
      next if node.value == 0

      #puts "doing #{node.value}"

      deq.current = node

      _, left, right = deq.remove_current

      deq.current = node.value > 0 ? right : left

      if node.value > 0
        deq.move_right(node.value - 1)
        deq.insert_right(node)
      else
        deq.move_left(node.value.abs - 1)
        deq.insert_left(node)
      end
    end
  end

  lst = deq.to_right_list.map(&:value)

  offset = lst.find_index { |n| n == 0 }

  #  puts lst.to_s

  cor = lst[offset..] + lst[0...offset]

  x, y, z = (1000) % deq.size, (2000) % deq.size, (3000) % deq.size

  #  puts [cor[x], cor[y], cor[z]].to_s

  [cor[x], cor[y], cor[z]].sum
end

tb = 1623178306

puts 'part 2'

ans = part2(aoc.test_data)

puts ans

aoc.run(2, tb, ans) do |data|
  part2(data)
end
