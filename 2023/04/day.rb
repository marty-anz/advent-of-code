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
    numbers = parts[1].split(" | ")
    wins = numbers[0].split(" ")
    ns = numbers[1].split(" ")

    win_map = Hash[wins.map { |d| [d, true] }]

    p = 0
    ns.each do |n|
      if win_map[n]
        if p == 0
          p = 1
        else
          p *= 2
        end
      end
    end

    p
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

    numbers = parts[1].split(" | ")
    wins = numbers[0].split(" ")
    ns = numbers[1].split(" ")

    win_map = Hash[wins.map { |d| [d, true] }]

    count = ns.map { |n| win_map[n] ? 1 : 0 }.sum

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
        new_cards[no] = 0 if new_cards[no].nil?
        new_cards[no] += count
      end
    end

    card_count += new_cards.values.sum

    cards = new_cards
  end

  card_count
end

ans = part2(aoc.test_data)

aoc.run(2, 30, ans) { |data| part2(data) }
