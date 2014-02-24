require 'pry'

@wins = []
@all_coords = Array(0..7).product(Array(0..7))

def new_board
  @board = {}

  @all_coords.each do |coords|
    @board[coords] = nil
  end
end

def safe?(board, cell)
  checks = []
  checks << lambda{|cell, other| cell[0] == other[0]}
  checks << lambda{|cell, other| cell[1] == other[1]}
  checks << lambda{|cell, other| (cell[0] - cell[1]) == (other[0] - other[1])}
  checks << lambda{|cell, other| (cell[0] + cell[1]) == (other[0] + other[1])}

  @all_coords.each do |coord|
    results = checks.map{|proc| proc.call(cell, coord)}
    if results.any? && board[coord]
      return false
    end
  end
  true
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

def iter_place_queens(input, queen_number = 0)
  system('clear')
  print_board(input)

  if queen_number == 8
    @wins << input
    puts "win!"
    print_board(input)
    gets
    return nil
  end

  row = input.keys[queen_number*8...(queen_number+1)*8]
  row.each do |index|
    board = input.dup
    if safe?(board, index)
      board[index] = true
      # puts "we have to go deeper"
      iter_place_queens(board, queen_number + 1)
    end
  end

end

system('clear')
new_board
iter_place_queens(@board)
for board in @wins
  print_board(board)
end
