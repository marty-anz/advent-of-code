# lib/matrix.rb

# 2d array Matrix functions

# Right = 0
# Down = 1
# Left = 2
# Up = 3

module M
  def turn_facing(facing, direct)
    if direct == 'R'
      case facing
      when Right
        Down
      when Down
        Left
      when Left
        Up
      when Up
        Right
      end
    else
      case facing
      when Right
        Up
      when Up
        Left
      when Left
        Down
      when Down
        Right
      end
    end
  end

  def self.size(data)
    [data.count, data.first.count]
  end

  def self.make(x, y, n)
    x.times.map { [n] * y }
  end

  def self.clone(data)
    data.map do |row|
      row.clone
    end
  end

  def self.up(_, r, c)
    (0..(r - 1)).to_a.reverse.map { |x| [x, c] }
  end

  def self.down(data, r, c)
    row, _ = dim(data)

    ((r + 1)...row).map { |x| [x, c] }
  end

  def self.left(_, r, c)
    (0..(c - 1)).to_a.reverse.map { |x| [r, x] }
  end

  def self.right(data, r, c)
    _, col = dim(data)

    ((c + 1)...col).map { |x| [r, x] }
  end

  def self.dim(data)
    [data.count, data.first.count]
  end

  def self.print(m)
    m.each { |r| puts r.join }
  end

  def self.element?(data, x, y)
    return false if x.negative? || y.negative?

    !(data[x] || [])[y].nil?
  end

  def self.each(data, &block)
    data.each_with_index do |row, x|
      row.each_with_index do |e, y|
        block.call(e, x, y)
      end
    end
  end

  def self.each!(data, &block)
    data.each_with_index do |row, x|
      row.each_with_index do |e, y|
        data[x][y] = block.call(e, x, y)
      end
    end
  end

  def self.map(data, &block)
    data.each_with_index.flat_map do |row, x|
      row.each_with_index.flat_map do |e, y|
        block.call(e, x, y)
      end
    end
  end

  def self.each_with_index(data, &block)
    data.each_with_index do |row, x|
      row.each_with_index do |e, y|
        block.call(e, x, y)
      end
    end
  end

  SurroundingDirection = {
    'N' => 0,
    'NE' => 1,
    'E' => 2,
    'SE' => 3,
    'S' => 4,
    'SW' => 5,
    'W' => 6,
    'NW' => 7
  }

  def self.surrounding(r, c)
    pos = []

    up = r - 1
    down = r + 1
    right = c + 1
    left = c - 1

    pos << [up, c] # north
    pos << [up, right] # north east

    pos << [r, right] # east

    pos << [down, right] # south east

    pos << [down, c] # south

    pos << [down, left] # south west
    #
    pos << [r, left] # west

    pos << [up, left] # north west

    pos
  end

  def self.bounded_surrounding(data, r, c)
    pos = []

    up = r - 1
    down = r + 1
    right = c + 1
    left = c - 1

    pos << [down, c] if element?(data, down, c)
    pos << [up, c] if element?(data, up, c)

    pos << [r, right] if element?(data, r, right)
    pos << [r, left] if element?(data, r, left)

    pos << [down, right] if element?(data, down, right)
    pos << [up, left] if element?(data, up, left)

    pos << [down, left] if element?(data, down, left)
    pos << [up, right] if element?(data, up, right)

    pos
  end

  def self.cross(r, c)
    up = r - 1
    down = r + 1
    right = c + 1
    left = c - 1

    [[down, c],
     [up, c],

     [r, right],
     [r, left]]
  end

  def self.bounded_cross(data, r, c)
    pos = []

    up = r - 1
    down = r + 1
    right = c + 1
    left = c - 1

    pos << [down, c] if element?(data, down, c)
    pos << [up, c] if element?(data, up, c)

    pos << [r, right] if element?(data, r, right)
    pos << [r, left] if element?(data, r, left)

    pos
  end

  def self.graph_from_matrix(matrix)
    g = {}
  end
end
