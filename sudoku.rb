require 'nokogiri'
require 'open-uri'
require 'pry-debugger'

@coords = (0..8).to_a.product((0..8).to_a)

class BackTrack < StandardError
end


def parse_page(page)
  (1..81).each_with_object([]) do |index, values|

    cell = page.css("##{index}").text
    values << (cell.empty? ?  0 : cell)
  end.join
end

def get_puzzle(difficulty = 1)
  page = Nokogiri::HTML(open("http://www.free-sudoku.com/sudoku.php?mode=#{difficulty}"))
  boardarray = parse_page(page).split('')

  acc = {}
  @coords.each do |i|
    acc[i] = boardarray.shift.to_i
  end

  acc
end

def return_square_set(n)
  i = n / 3
  case i
  when 0
    [0,1,2]
  when 1
    [3,4,5]
  when 2
    [6,7,8]
  end
end

def return_square(coords)
  @coords.reject do |co|
    return_square_set(co[0]) != return_square_set(coords[0]) ||
    return_square_set(co[1]) != return_square_set(coords[1])
  end
end

def get_friends(co)
  acc = []
  @coords.each do |cand|
    acc << cand if co[0] == cand[0]
    acc << cand if co[1] == cand[1]
  end
  return_square(co).each {|e| acc << e}
  acc
end

def cell_poss(puzzle, co)
  acc = []
  get_friends(co).each do |friend|
    acc << puzzle[friend]
  end
  poss = [1,2,3,4,5,6,7,8,9] - acc.uniq.reject{|e|e==0}

  if puzzle[[co[0],co[1]]] != 0
    [puzzle[[co[0],co[1]]]]
  else
    poss
  end
end

def all_cell_poss(puzzle, co)
  acc = []

  test = get_friends(co)
  test.delete co
  # binding.pry

  test.each do |friend|
    acc << puzzle[friend]
  end
  poss = [0,1,2,3,4,5,6,7,8,9] - acc.uniq
  poss
end

def dead_puzzle?(puzzle)

  if all_poss(puzzle).values.include? []
    return true
  end

  puzzle.each do |k,v|
    if v != 0
      test = all_cell_poss(puzzle, k)
      if !test.include?(v)
        return true
      end
    end
  end
  return false
end

def print_puzzle(puzzle)
  puzzle.values.each_slice(9).to_a.each do |a|
    a.each do |e|
      if e == 0
        print '. '
      else
        print e.to_s + ' '
      end
    end
    print "\n"
  end
end


def deterministic_solve(puzzle)

  if dead_puzzle?(puzzle)
    raise BackTrack
  end

  acc = Marshal.load(Marshal.dump(puzzle))

  puzzle.each_key do |k|
    if cell_poss(acc, k).length == 1
      val = cell_poss(acc, k).first
      acc[k] = val
    else
      acc[k] = puzzle[k]
    end
  end

  # system "clear"
  # print_puzzle acc
  # puts

  if acc == puzzle
    return acc
  else
    binding.pry if acc.values.include? nil
    deterministic_solve(acc)
  end

end

def all_poss(puzzle)
  acc = {}
  puzzle.each_key do |k|
    acc[k] = cell_poss(puzzle, k)
  end
  acc
end

def list_moves(puzzle)
  acc = []
  all = all_poss(puzzle).sort_by {|k,v| v.length}
  all.reject! {|k,v| v.length == 1}
  all.each do |k, v|
    v.each do |e|
      acc << [k,e]
    end
  end
  acc
end

def make_move(puzzle, move)
  binding.pry if move[1].nil?
  puzzle[move[0]] = move[1]

  if dead_puzzle?(puzzle)
    # "Dead puzzle!"
    raise BackTrack
  end

  # system "clear"
  # print_puzzle puzzle
  # puts "================="
  # puts

  puzzle
end

def try_moves(puzzle, moves)
  if moves.empty?
    raise BackTrack
  end
  next_puzzle = make_move(puzzle, moves.first)
  begin
    solve next_puzzle
  rescue BackTrack
    try_moves(puzzle, moves[1..-1])
  end
end


def solve(puzzle)

  new_puzzle = deterministic_solve puzzle
  if !new_puzzle.values.include? 0
    return new_puzzle
  else
    try_moves(new_puzzle, list_moves(new_puzzle))
  end
end

# x = get_puzzle 3

# @test_puzzle = {}
# @test = "4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......".gsub(".","0").split('')
# @coords.each do |i|
#   @test_puzzle[i] = @test.shift.to_i
# end


# @recursions = 0
# # print_puzzle(deterministic_solve(@test_puzzle))
# #
# puts

# solve x
# puts "Recursions: #{@recursions}"

