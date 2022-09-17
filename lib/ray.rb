# frozen_string_literal: false

# Ray module creates an array with four nested arrays: horizontal spaces, 
# vertical spaces and both diagonals that are coming out of the coordinates on
# Connect Four board
module Ray
  def get_rays(column = @last_column_index, row = @last_free_space)
    vertical_ray = @board[column]

    horizontal_ray = []
    @board.each { |col| horizontal_ray << col[row] }

    left_upper_diagonal = get_left_upper_diagonal(column, row)
    left_lower_diagonal = get_left_lower_diagonal(column, row)
    left_diagonal = left_upper_diagonal + left_lower_diagonal

    right_upper_diagonal = get_right_upper_diagonal(column, row)
    right_lower_diagonal = get_right_lower_diagonal(column, row)
    right_diagonal = right_lower_diagonal + right_upper_diagonal

    [vertical_ray, horizontal_ray, left_diagonal, right_diagonal]
  end

  def get_left_upper_diagonal(column, row, left_upper_diagonal = [])
    loop do
      break if row > 5 || column.negative?

      left_upper_diagonal << @board[column][row]
      column -= 1
      row += 1
    end
    left_upper_diagonal
  end

  def get_left_lower_diagonal(column, row, left_lower_diagonal = [])
    column += 1
    row -= 1
    loop do
      break if row.negative? || column > 6

      left_lower_diagonal << @board[column][row]
      column += 1
      row -= 1
    end
    left_lower_diagonal
  end

  def get_right_upper_diagonal(column, row, right_upper_diagonal = [])
    loop do
      break if row > 5 || column > 6

      right_upper_diagonal << @board[column][row]
      column += 1
      row += 1
    end
    right_upper_diagonal
  end

  def get_right_lower_diagonal(column, row, right_lower_diagonal = [])
    column -= 1
    row -= 1
    loop do
      break if row.negative? || column.negative?

      right_lower_diagonal << @board[column][row]
      column -= 1
      row -= 1
    end
    right_lower_diagonal
  end
end
