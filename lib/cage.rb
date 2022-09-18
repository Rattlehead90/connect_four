# frozen_string_literal: false
require 'colorize'
require_relative '../lib/ray'

# a class that depicts a cage used in the game.
class Cage
  include Ray
  attr_accessor :board, :move
  attr_reader :last_column_index, :last_free_space

  def initialize(move = nil)
    @board = Array.new(7) { Array.new(6, '⚪') }
    @move = move
  end

  def possible_moves(possible_moves = [])
    @board.each do |column|
      possible_moves << column.find_index('⚪')
    end
    possible_moves
  end

  def display(index = -1, string = '')
    return if index < -6

    @board.each do |column|
      string << column[index]
    end
    puts string
    display(index - 1)
  end

  def place_token(column_index, token = '⚫')
    free_space = possible_moves[column_index]
    @last_column_index = column_index
    @last_free_space = free_space
    @board[column_index][free_space] = token
  end

  def player_turn
    loop do
      @move = validate_input(player_input)
      break if @move

      puts 'Invalid input!'
    end
  end

  def game_over?
    # column and row are indices of a last move
    rays = get_rays
    game_over = false
    rays.each do |ray|
      player1_tokens = ray.each_index.select { |space| ray[space] == '⚫' }
      player2_tokens = ray.each_index.select { |space| ray[space] == '⚫'.red }
      game_over = true if four_consecutive?(player1_tokens)
      game_over = true if four_consecutive?(player2_tokens)
    end
    game_over
  end

  def game_loop
    loop do
      display
      player_turn
      place_token(@move.to_i - 1, '⚫')
      break if game_over?

      display
      player_turn
      place_token(@move.to_i - 1, '⚫'.red)
      break if game_over?
    end
    display
    puts 'game over'
  end

  def validate_input(column_number)
    return column_number if column_number.match?(/^[1-7]$/) &&
                            !possible_moves[column_number.to_i - 1].nil?
  end

  private

  def four_consecutive?(ray)
    return false unless ray.length == 4

    ray.each_cons(2).all? { |a, b| b == a + 1 }
  end

  def player_input
    puts 'Enter a number of a column you wish to place token in (1 - 7)'
    gets.chomp
  end
end
