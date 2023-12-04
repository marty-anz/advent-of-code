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
  input.map do |line|
    parts = line.split(": ")
    wins, ns = parts[1].split(" | ").map { |p| p.split(" ") }

    win_map = Hash[wins.map { |d| [d, true] }]

    p = ns.filter { |n| win_map[n] }.count

    (2 ** (p - 1)).to_i
  end.sum
end

ans = part1(aoc.test_data)

aoc.run(1, 13, ans) { |data| part1(data) }

def part2(input)
  win_cards = {}

  cards = []

  input.map do |line|
    parts = line.split(": ")
    card_no = parts[0].split(" ").last.to_i
    wins, ns = parts[1].split(" | ").map { |p| p.split(" ") }

    win_map = Hash[wins.map { |d| [d, true] }]

    count = ns.filter { |n| win_map[n] }.count

    win_cards[card_no] = []

    count.times do |i|
      win_cards[card_no] << (card_no + i + 1)
    end

    cards << card_no
  end

  card_count = cards.count

  cards = Hash[cards.map { |card| [card, 1] }]

  while !cards.empty?
    new_cards = {}

    cards.each do |card, count|
      win_cards[card].each do |no|
        new_cards[no] = (new_cards[no] || 0) + count
      end
    end

    card_count += new_cards.values.sum

    cards = new_cards
  end

  card_count
end

ans = part2(aoc.test_data)

aoc.run(2, 30, ans) { |data| part2(data) }
