# frozen_string_literal: false

# a class that depicts a cage used in the game.
class Cage
  attr_accessor :board

  def initialize
    @board = Array.new(7) { Array.new(6, 'o') }
  end

  def possible_moves(possible_moves = [])
    @board.each do |column|
      possible_moves << column.find_index('o')
    end
    possible_moves.all?(nil) ? nil : possible_moves
  end

  def display(index = -1, string = '')
    return if index < -6

    @board.each do |column|
      string << column[index]
    end
    puts string
    display(index - 1)
  end

  def place_token(column_index, token = 'x')
    free_space = possible_moves[column_index]
    @board[column_index][free_space] = token
  end

  def validate_input(input)
    
  end
end
