require_relative "sudoku.rb"

def ingest
  coords = (0..8).to_a.product((0..8).to_a)
  problems = File.open("suds.txt").read.split

  probs = []

  50.times do
    acc = []
    problems.shift
    problems.shift
    9.times do
      acc << problems.shift
    end
    probs << acc
  end

  probs.map! do |e|
    e = e.join
  end

  all = []
  probs.each do |e|
    acc = {}
    puz = e.split('')
    coords.each do |i|
      acc[i] = puz.shift.to_i
    end
    all << acc
  end
  all
end

p ingest
gets

sum = 0
ingest[0..4].each do |puzzle|
  this = solve(puzzle)
  adder = [this[[0,0]],this[[0,1]],this[[0,2]]].join.to_i
  sum += adder
end

File.open("solution.txt", "w+") {|t| t.write(sum) }

