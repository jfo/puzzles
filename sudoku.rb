require 'nokogiri'
require 'open-uri'
require 'pry'

@coords = (0..8).to_a.product((0..8).to_a)

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

  acc.uniq
end

def cell_poss(puzzle, co)
  acc = []
  get_friends(co).each do |friend|
    acc << puzzle[friend]
  end
  [1,2,3,4,5,6,7,8,9] - acc.uniq.reject{|e|e==0}
end

def print_puzzle(puzzle)
  puzzle.values.each do |e|
    print e
  end
end

def deterministic_solve(puzzle)

  acc = {}

  puzzle.each_key do |k|
    if cell_poss(puzzle, k).length == 1 && puzzle[k] == 0
      acc[k] = cell_poss(puzzle, k)[0]
    else
      acc[k] = puzzle[k]
    end
  end

  return acc if acc == puzzle
  deterministic_solve(acc)
end

def make_move(puzzle, move)
  puzzle[move[0]] = move[1]
  puzzle
end

def allposs(puzzle)
  acc = {}
  puzzle.each_key do |k|
    acc[k] = cell_poss(puzzle, k)
  end
  acc2 = []
  acc.each do |k,v|
    v.each do |e|
      acc2 << [k,e]
    end
  end
  acc2.sort_by {|k, v| acc[k].length }
end

def try_moves(puzzle, moves)
   if moves.empty?
    raise Exception.new("nope!")
   else
     p "hi"
    next_puzzle = make_move(puzzle, moves.shift)
    begin
      solve(next_puzzle)
    rescue Exception
      try_moves(puzzle, moves)
    end
  end
end

def solve(puzzle)
  new_puzzle = deterministic_solve(puzzle)
  return new_puzzle if !new_puzzle.values.include? 0
  try_moves(new_puzzle, allposs(new_puzzle))
end


x = get_puzzle 2
p allposs(deterministic_solve(x))

print_puzzle(x)
puts
print_puzzle(deterministic_solve(x))
puts
print_puzzle(solve(x))
# p allposs(x)

