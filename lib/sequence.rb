# lib/sequence.rb

ROW, COL = 0, 1

INF = 999999999

def list?(a)
  a.kind_of? Array
end

def int?(a)
  a.kind_of? Integer
end

def list_ranges(lst)
  sz = lst.first.size
  ranges = sz.times.map { [INF, -INF] }

  lst.each do |l|
    l.each_with_index do |v, i|
      if v < ranges[i][0]
        ranges[i][0] = v
      elsif v > ranges[i][1]
        ranges[i][1] = v
      end
    end
  end

  ranges.map do |s, e|
    s..e
  end
end

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
