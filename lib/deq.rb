# double linked queue

class Deq
  class Node
    attr_accessor :value, :right, :left

    def initialize(value, right, left)
      @value = value
      @right = right
      @left = left
    end
  end

  attr_accessor :current
  attr_reader :nodes, :size

  def initialize(lst)
    @size = lst.size

    @nodes = lst.map do |l|
      Node.new(l, nil, nil)
    end

    @nodes.size.times do |i|
      @nodes[i].right = @nodes[(i + 1) % @size]
      @nodes[i].left = @nodes[i - 1]
    end

    @current = @nodes.first
  end

  def remove_current()
    @current.left.right = @current.right
    @current.right.left = @current.left

    l, r = @current.left, @current.right
    @current.left = @current.right = nil

    @size -= 1

    return @current, l, r
  end

  def move_left(i)
    (i % @size).times { @current = @current.left }
  end

  def move_right(i)
    (i % @size).times { @current = @current.right }
  end

  def insert_left(node)
    @current.left.right = node
    node.left = @current.left
    @current.left = node
    node.right = @current

    @size += 1
    @current = node
  end

  def insert_right(node)
    @current.right.left = node
    node.right = @current.right
    @current.right = node
    node.left = @current

    @size += 1
    @current = node
  end

  def to_right_list
    list = []
    @size.times do
      list << @current

      move_right(1)
    end

    list
  end

  def to_left_list
    list = []
    @size.times do
      list << @current

      move_left(1)
    end

    list
  end
end
