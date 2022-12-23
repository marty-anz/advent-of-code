# lib/aoc.rb

class Aoc
  attr :workdir, :year, :day, :postload, :input_file

  def initialize(workdir, &block)
    @workdir = workdir
    @year, @day = self.workdir.split('/')[-2..-1].map(&:to_i)

    @input_file = "#{self.workdir}/input.txt"
    @postload = block ? block : ->(x) { x }
  end

  def download
    if File.exist?(input_file)
      `rm #{workdir}/puzzle.md`
      `aoc download --year #{year} --day #{day} --description-only`
    else
      `aoc download --year #{year} --day #{day} --input-file #{input_file}`
    end
  end

  def test_data
    x = File.read("#{self.workdir}/test_input.txt").lines
    self.postload.call(x)
  end

  def data
    x = File.read(input_file).lines
    self.postload.call(x)
  end

  def run(part_no, expected, actual, &block)
    ans = block.call(self.data)

    if expected.nil?
      puts "part #{part_no} test data is not set"
      return
    end

    if expected != actual
      puts "part #{part_no} test answer is not correct expected: #{expected} actual: #{actual}"
      return
    end

    puts ans

    ans_file = "#{self.workdir}/part#{part_no}_answer"
    unless File.exist?(ans_file)
      resp = `aoc submit --year #{year} --day #{day} #{part_no} #{ans}`

      puts resp

      `echo #{ans} > #{ans_file}` unless resp.=~ /not the right answer/
    end

    true
  end
end
