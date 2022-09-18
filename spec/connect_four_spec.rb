require_relative '../lib/cage'

# Here is a summary of what should be tested
# 1. Command Method -> Test the change in the observable state
# 2. Query Method -> Test the return value
# 3. Method with Outgoing Command -> Test that a message is sent
# 4. Looping Script Method -> Test the behavior of the method

describe Cage do
  describe '#initialize' do
    subject(:initialized_cage) { described_class.new }

    context 'when the cage is initialized' do
      it 'has 7 columns' do
        columns = initialized_cage.board.length
        expect(columns).to eq(7)
      end

      it 'has 6 rows' do
        row = initialized_cage.board[0].length
        expect(row).to eq(6)
      end
    end
  end

  describe '#possible_moves' do
    subject(:initialized_cage) { described_class.new }

    context 'when there are no tokens in the cage' do
      it 'returns the indices of the first row' do
        # for each column it should return a minimum possible empty space
        possible_moves = initialized_cage.possible_moves
        first_row_moves = Array.new(7, 0)
        expect(possible_moves).to eq(first_row_moves)
      end
    end

    context 'when there are tokens in the cage' do
      context 'when the cage has 1, 2, 3, 4, 3, 2, 1 tokens in the columns' do
        before do
          board_to_set = [
            %w[⚫ ⚪ ⚪ ⚪ ⚪ ⚪],
            %w[⚫ ⚫ ⚪ ⚪ ⚪ ⚪],
            %w[⚫ ⚫ ⚫ ⚪ ⚪ ⚪],
            %w[⚫ ⚫ ⚫ ⚫ ⚪ ⚪],
            %w[⚫ ⚫ ⚫ ⚪ ⚪ ⚪],
            %w[⚫ ⚫ ⚪ ⚪ ⚪ ⚪],
            %w[⚫ ⚪ ⚪ ⚪ ⚪ ⚪]
          ]
          initialized_cage.instance_variable_set(:@board, board_to_set)
        end

        it 'returns 1, 2, 3, 4, 3, 2, 1 indices' do
          topmost_tokens = [0, 1, 2, 3, 2, 1, 0]
          topmost_free_places = topmost_tokens.map { |place| place + 1 }
          possible_moves = initialized_cage.possible_moves
          expect(possible_moves).to eq(topmost_free_places)
        end
      end

      context 'when the cage has one row left' do
        before do
          board_to_set = [
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚪],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚪],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚪],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚪],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚪],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚪],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚪]
          ]
          initialized_cage.instance_variable_set(:@board, board_to_set)
        end

        it 'returns 5, 5, 5, 5, 5, 5, 5 indices' do
          topmost_tokens = [4, 4, 4, 4, 4, 4, 4]
          topmost_free_places = topmost_tokens.map { |place| place + 1 }
          possible_moves = initialized_cage.possible_moves
          expect(possible_moves).to eq(topmost_free_places)
        end
      end

      context 'when there is no possible moves in the cage' do
        before do
          board_to_set = [
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚫],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚫],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚫],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚫],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚫],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚫],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚫]
          ]
          initialized_cage.instance_variable_set(:@board, board_to_set)
        end
        it 'returns nil array' do
          possible_moves = initialized_cage.possible_moves
          nil_array = Array.new(7, nil)
          expect(possible_moves).to eq(nil_array)
        end
      end
    end
  end

  describe '#display' do
    subject(:middlegame_cage) { described_class.new }

    context 'when called for' do
      it 'receives :puts 6 times' do
        expect(middlegame_cage).to receive(:puts).exactly(6).times
        middlegame_cage.display
      end
    end
  end

  describe '#validate_input' do
    subject(:input_loop) { described_class.new }

    context 'when presented with two invalid and one valid inputs' do
      before do
        letter = 's'
        wrong_number = '8'
        valid_input = '3'
        allow(input_loop).to receive(:player_input).and_return(letter, wrong_number, valid_input)
      end

      it 'throws an error two times and then returns the valid input' do
        expect(input_loop).to receive(:puts).with('Invalid input!').twice
        input_loop.player_turn
      end
    end
  end

  describe '#place_token' do
    subject(:initialized_cage) { described_class.new }

    context 'when the grid is empty' do
      it 'places the token in the chosen column' do
        initialized_cage.place_token(3)
        board = initialized_cage.instance_variable_get(:@board)
        board_with_a_new_token = [
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚫ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪]
        ]
        expect(board).to eq(board_with_a_new_token)
      end
    end

    # There is, then, a question which class should validate it's input. The
    # input is deemed validated when it's under the 0 to 5 limit and is possible.
    # Player may 'hold' the value in until it's under the limit but it will 
    # require a fetch of possible moves from the Cage. The cage, on the other
    # hand, has the possible moves stored and ready to use. 

    context 'when the input is wrong' do
      context 'when a full column two times in a row and then a possible move' do
        before do
          board_to_set = [
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚫],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚫],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚫],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚫],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚪],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚫],
            %w[⚫ ⚫ ⚫ ⚫ ⚫ ⚫]
          ]
          initialized_cage.instance_variable_set(:@board, board_to_set)
          allow(initialized_cage).to receive(:player_input).and_return('3', '4', '5')
        end
        it 'throws a warning two times until the input is correct' do
          expect(initialized_cage).to receive(:puts).with('Invalid input!').twice
          initialized_cage.player_turn
        end
      end
    end
  end

  describe '#game_over?' do
    subject(:endgame_cage) { described_class.new }

    context '4 vertically consecutive tokens' do
      before do
        end_state = [
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚫ ⚫ ⚫ ⚫ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
        ]
        endgame_cage.instance_variable_set(:@board, end_state)
        endgame_cage.instance_variable_set(:@last_column_index, 2)
        endgame_cage.instance_variable_set(:@last_free_space, 3)
      end
      
      it 'wins' do
        expect(endgame_cage).to be_game_over
      end
    end

    context '4 diagonally consecutive tokens' do
      before do
        end_state = [
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚫ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚫ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚫ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚫ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
        ]
        endgame_cage.instance_variable_set(:@board, end_state)
        endgame_cage.instance_variable_set(:@last_column_index, 5)
        endgame_cage.instance_variable_set(:@last_free_space, 3)
      end
      
      it 'wins' do
        expect(endgame_cage).to be_game_over
      end
    end
    
    context '4 horizontally consecutive tokens' do
      before do
        end_state = [
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚫ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚫ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚫ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚫ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
        ]
        endgame_cage.instance_variable_set(:@board, end_state)
        endgame_cage.instance_variable_set(:@last_column_index, 5)
        endgame_cage.instance_variable_set(:@last_free_space, 0)
      end
      
      it 'wins' do
        expect(endgame_cage).to be_game_over
      end
    end
    
    context 'a possible real-life situation' do
      before do
        end_state = [
          %w[☉ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚫ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[☉ ⚫ ⚪ ⚪ ⚪ ⚪],
          %w[☉ ☉ ⚫ ⚪ ⚪ ⚪],
          %w[☉ ☉ ☉ ⚫ ⚪ ⚪],
          %w[⚫ ☉ ⚫ ⚪ ⚪ ⚪],
          %w[☉ ⚪ ⚪ ⚪ ⚪ ⚪],
        ]
        endgame_cage.instance_variable_set(:@board, end_state)
        endgame_cage.instance_variable_set(:@last_column_index, 4)
        endgame_cage.instance_variable_set(:@last_free_space, 3)
      end
      
      it 'ignores the tokens of an opponent' do
        expect(endgame_cage).to be_game_over
      end
    end

    context 'non a game-over' do
      before do
        end_state = [
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚫ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[☉ ⚫ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[☉ ☉ ☉ ⚫ ⚪ ⚪],
          %w[⚫ ⚫ ⚫ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
        ]
        endgame_cage.instance_variable_set(:@board, end_state)
        endgame_cage.instance_variable_set(:@last_column_index, 4)
        endgame_cage.instance_variable_set(:@last_free_space, 3)
      end

      it 'does not falsely throw a game over' do
        expect(endgame_cage).not_to be_game_over
      end
    end
  end
end
