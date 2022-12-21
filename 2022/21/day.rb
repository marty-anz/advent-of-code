#!/usr/bin/env ruby

require '../../lib/aoc'
require '../../lib/hash' # H
require '../../lib/matrix' # M
require '../../lib/graph' # M
require '../../lib/sequence'
require '../../lib/deq'

aoc = Aoc.new(__dir__) do |data|
  data.map(&:strip)
end

def eval_result(monkey, state)
  # puts "monkey #{monkey}"
  return state[monkey][:result] unless state[monkey][:result].nil?

  m = state[monkey]
  left, op, right = m[:cmd]

  if !int?(left)
    left = eval_result(left, state)
  end

  if op.nil?
    return m[:result] = left
  end

  if !int?(right)
    right = eval_result(right, state)
  end

  m[:result] = if op == '+'
      left + right
    elsif op == '-'
      left - right
    elsif op == '/'
      left / right
    elsif op == '*'
      left * right
    end
end

def part1(data)
  state = {}
  data.each do |line|
    monkey, cmd = line.split(':').map(&:strip)

    cmd = cmd.split.map(&:strip).map do |i|
      i =~ /^\d+$/ ? (i.to_i) : i
    end

    state[monkey] = {
      cmd: cmd,
      result: nil
    }
  end

  eval_result('root', state)
end

ta = 152

ans = part1(aoc.test_data)

res = aoc.run(1, ta, ans) do |data|
  part1(data)
end

tb = 301
aoc.download if res && tb.nil?

def eval_delay(monkey, state)
  return 'x' if monkey == 'humn'
  return state[monkey][:result] unless state[monkey][:result].nil?

  m = state[monkey]
  left, op, right = m[:cmd]

  if !int?(left)
    left = eval_delay(left, state)
  end

  if op.nil?
    return m[:result] = left
  end

  if !int?(right)
    right = eval_delay(right, state)
  end

  if int?(left) && int?(right)
    m[:result] = if op == '+'
        left + right
      elsif op == '-'
        left - right
      elsif op == '/'
        left / right
      elsif op == '*'
        left * right
      end
  else
    m[:result] = [] if m[:result].nil?

    m[:result] += [left, op, right]
  end
end

def eval_nested_expr(expr, right)
  #  puts expr.to_s

  while expr != 'x'
    a, op, b = expr

    if int?(a)
      if op == '-' # a - b = right
        right = a - right  #
      elsif op == '+' # a + b = right
        right -= a # b = right - a
      elsif op == '/' # a/b  = right
        right = a / right # b = a / right
      elsif op == '*' # a * b = right
        right /= a # b = right/ a
      end
      expr = b
    elsif int?(b)
      # x * b = right
      # x = right / b
      if op == '-' # a - b = right
        right += b # a = right + b
      elsif op == '+' # a + b = right
        right -= b # a = right - b
      elsif op == '/' # a / b = right
        right *= b # a = right  * b
      elsif op == '*' # a * b = right
        right /= b # a = right / b
      end
      expr = a
    else
      puts 'wrong expr'
      break
    end

    #  puts "#{[a, op, b]} #{right}"
  end

  right
end

def part2(data)
  state = {}

  data.each do |line|
    monkey, cmd = line.split(':').map(&:strip)

    cmd = cmd.split.map(&:strip).map do |i|
      i =~ /^\d+$/ ? i.to_i : i
    end

    state[monkey] = {
      cmd: cmd,
      result: nil
    }
  end

  state['humn'] = 'x'

  eval_delay('root', state)

  m1 = state['root'][:cmd][0]
  m2 = state['root'][:cmd][2]

  left = state[m1][:result]
  right = state[m2][:result].to_i

  eval_nested_expr(left, right)
end

puts 'part 2'

ans = part2(aoc.test_data)
puts ans

aoc.run(2, tb, ans) do |data|
  part2(data)
end
