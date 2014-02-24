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


class Hash
  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end
end

def safe?(board, cell)

  if check_x(board, cell).values.include?(true) ||
     check_y(board, cell).values.include?(true) ||
     check_45(board, cell).values.include?(true) ||
     check_135(board, cell).values.include?(true) ||
    false
  else
    true
  end

end


def check_x(board, cell)
  # for a given coord, return a sub hash of all the spots on its x axis
  x_mates = {}

  @all_coords.each do |coords|
    x_mates[coords] = board[coords] if cell[0] == coords[0]
  end

  x_mates.except!(cell)
end


def check_y(board, cell)

  x_mates = {}

  @all_coords.each do |coords|
    x_mates[coords] = board[coords] if cell[1] == coords[1]
  end

  x_mates.except!(cell)
end


def check_45(board,  cell)
  ff_mates = {}

  @all_coords.each do |coords|
    ff_mates[coords] = board[coords] if (cell[0] - cell[1]) == (coords[0] - coords[1])
  end
  ff_mates
end


def check_135(board, cell)
  otf_mates = {}

  @all_coords.each do |coords|
    otf_mates[coords] = board[coords] if (cell[0] + cell[1]) == (coords[0] + coords[1])
  end
  otf_mates
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
