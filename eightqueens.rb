require 'pry'

@i = 0
@wins = []
@all_coords = Array(0..7).product(Array(0..7))

def new_board
  @board = {}

  @all_coords.each do |coords|
    @board[coords] = nil
  end
end

def generic_check(board, cell, check)
  mates = []
  @all_coords.each do |coord|
    mates << board[coord] if check.call(cell, coord)
  end
  mates
end

def safe?(board, cell)
  check_x = lambda{|cell, other| cell[0] == other[0]}
  check_y = lambda{|cell, other| cell[1] == other[1]}
  check_45 = lambda{|cell, other| (cell[0] - cell[1]) == (other[0] - other[1])}
  check_135 = lambda{|cell, other| (cell[0] + cell[1]) == (other[0] + other[1])}

  if generic_check(board, cell, check_x).include?(true) ||
     generic_check(board, cell, check_y).include?(true) ||
     generic_check(board, cell, check_45).include?(true) ||
     generic_check(board, cell, check_135).include?(true)
      false
  else
    true
  end

end


def print_board(board)

  x = 0
  y = 0
  until x == 8
    until y == 8
      if board[[x,y]] == true
        print "Q "
      else
        if safe?(board, [x,y]) == true
          print '. '
        else
          print 'X '
        end
      end
    y+=1
    end
    print "\n"
    y = 0
    x +=1
  end
end

def iter_place_queens(input, count = 0)

  puts "=============================="
  system('clear')
  print_board(input)
  sleep 0.05

  if count == 8
    @wins << input
    print "win!"
    gets
    return nil
  end

  input.keys.each do |index|
    board = input.dup
    if place_queen(board, index)
      iter_place_queens(board, count + 1)
    end
  end
end


def place_queen(board, ix)

  if safe?(board, ix)
    board[ix] = true
    return true
  else
    return false
  end

end

system('clear')
new_board
iter_place_queens(@board)
for board in @wins
  print_board(board)
end
