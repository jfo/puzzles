require 'pry'

@all_coords = Array(0..7).product(Array(0..7))

def new_board

  @all_coords.each do |coords|
    @board ||= {}
    @board[coords] = nil
  end

end


class Hash
  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end
end


def check_all(cell)

  all = check_x(cell) + check_y(cell) + check_45(cell) + check_135(cell)
  all.values.include?(True)

end


def check_x(cell)
  # for a given coord, return a sub hash of all the spots on its x axis
  x_mates = {}

  @all_coords.each do |coords|
    x_mates[coords] = @board[coords] if cell[0] == coords[0]
  end

  x_mates.except!(cell)
end


def check_y(coords)

  x_mates = {}

  @all_coords.each do |loccoords|
    x_mates[coords] = @board[coords] if cell[1] == coords[1]
  end

  x_mates.except!(cell)
end


def check_45(coords)
end


def check_135(coords)
end

binding.pry
