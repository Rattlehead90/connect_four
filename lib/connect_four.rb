# frozen_string_literal: false

# An orchestrating encapsulation for the Cage class
class ConnectFour
  def initialize
    introduction
    @game = Cage.new
    @game.game_loop
  end

  def introduction
    puts <<~HEREDOC

      CONNECT FOUR

      "...a two-player connection board game, in which the players choose a color 
      and then take turns dropping colored tokens into a seven-column, six-row 
      vertically suspended grid. The pieces fall straight down, occupying the 
      lowest available space within the column. The objective of the game is to 
      be the first to form a horizontal, vertical, or diagonal line of four of 
      one's own tokens. " -- Wikipedia

      This implementation of Connect Four was done solely to practice TDD method of
      development for the Odin Project.

      Let the game begin!

    HEREDOC
  end
end
