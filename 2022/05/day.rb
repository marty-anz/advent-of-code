#!/usr/bin/env ruby

ta = 'CMZ'
tb = 'MCD'

def load_data(file)
  File.read("#{__dir__}/#{file}").lines.map(&:strip)
end

def test_data
  load_data('test_input.txt')
end

def data
  load_data('input.txt')
end

def test_state
  [
    ['N', 'Z'],
    ['D', 'C', 'M'],
    ['P']
  ]
end

def state
  [
    %w[W L S],
    %w[Q N T J],
    %w[J F H C S],
    %w[B G N W M R T],
    %w[B Q H D S L R T],
    %w[L R H F V B J M],
    %w[M J N R W D],
    %w[J D N H F T Z B],
    %w[T F B N Q L H]
  ]
end

#                 [B] [L]     [J]
#             [B] [Q] [R]     [D] [T]
#             [G] [H] [H] [M] [N] [F]
#         [J] [N] [D] [F] [J] [H] [B]
#     [Q] [F] [W] [S] [V] [N] [F] [N]
# [W] [N] [H] [M] [L] [B] [R] [T] [Q]
# [L] [T] [C] [R] [R] [J] [W] [Z] [L]
# [S] [J] [S] [T] [T] [M] [D] [B] [H]

def part1(s, moves)
  moves.each do |l|
    next if l[0] != 'm'

    c = l.split
    step, from, to = c[1].to_i, c[3].to_i - 1, c[5].to_i - 1

    b = step.times.map { s[from].shift }.reverse

    s[to] = b + s[to]
  end

  s.map { |e| e[0] }.join
end

def part2(s, moves)
  moves.each do |l|
    next if l[0] != 'm'

    c = l.split
    step, from, to = c[1].to_i, c[3].to_i - 1, c[5].to_i - 1

    b = step.times.map { s[from].shift }

    s[to] = b + s[to]
  end

  s.map { |e| e[0] }.join
end

t = part1(test_state, test_data)
if t == ta
  a = part1(state, data)
  puts a

  unless File.exist?('./part1_answer')
    puts `~/bin/aocs 1 #{a}`
    `echo #{a} > part1_answer`
  end
else
  puts "part 1 test answer is not correct expected: #{ta} actual: #{t}"
end

t = part2(test_state, test_data)
if t == tb
  a = part2(state, data)
  puts a

  if File.exist?('./part1_answer') && !File.exist?('./part2_answer')
    puts `~/bin/aocs 2 #{a}`
    `echo #{a} > part2_answer`
  end
else
  puts "part 2 test answer is not correct expected: #{tb} actual: #{t}"
end
