# lib/hash.rb

module H
  class << self
    def h(keys, values)
      Hash[
        keys.each_with_index.map do |k, i|
          [k, values[i]]
        end
      ]
    end

    def brackets
      {
        '(' => ')',
        '[' => ']',
        '{' => '}',
        '<' => '>'
      }
    end

    def reverse_brackets
      swap_key_value(brackets)
    end

    def swap_key_value(h)
      Hash[
        h.map do |k, v|
          [v, k]
        end
      ]
    end
  end
end
