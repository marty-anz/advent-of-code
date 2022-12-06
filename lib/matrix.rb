# lib/matrix.rb

# 2d array Matrix functions
module M
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
