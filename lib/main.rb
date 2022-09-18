# frozen_string_literal: false
require_relative '../lib/cage'

# An orchestrating encapsulation for the Cage class
class ConnectFour
  def initialize
    @game = Cage.new
    @game.game_loop
  end
end

connect_four = ConnectFour.new
