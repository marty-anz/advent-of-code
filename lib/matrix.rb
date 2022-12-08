# lib/matrix.rb

# 2d array Matrix functions
module M
  def self.make(x, y, n)
    x.times.map { [n] * y }
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

  def self.surrounding(data, r, c)
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

  def self.cross(data, r, c)
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
end
