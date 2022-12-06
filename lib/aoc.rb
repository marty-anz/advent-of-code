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
    x = File.read("#{self.workdir}/test_input.txt").lines.map(&:strip)
    self.postload.call(x)
  end

  def data
    x = File.read(input_file).lines.map(&:strip)
    self.postload.call(x)
  end

  def run(part_no, expected, actual, &block)
    if expected.nil?
      puts "part #{part_no} test data is not set"
      return
    end

    if expected != actual
      puts "part #{part_no} test answer is not correct expected: #{expected} actual: #{actual}"
      return
    end

    ans = block.call(self.data)

    puts ans

    ans_file = "#{self.workdir}/part#{part_no}_answer"
    unless File.exist?(ans_file)
      puts `aoc submit --year #{year} --day #{day} #{part_no} #{ans}`
      `echo #{ans} > #{ans_file}`
    end

    download if part_no == 1 && !File.exist?("#{self.workdir}/part2_answer")
  end
end
