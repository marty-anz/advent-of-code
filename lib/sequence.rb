# lib/line.rb

module S
  def self.split(s)
    s.split.map do |e|
      e =~ /^\d+$/ ? e.to_i : e
    end
  end

  def self.ints(s)
    s.split.filter do |e|
      e =~ /^\d+$/
    end.map(&:to_i)
  end

  # Take n from i position
  def self.take(s, i, n)
    s[i..(i + n - 1)]
  end
end
