require 'minitest/autorun'
require_relative '../lib/tic_tac_toe'

class TicTacToeTest < Minitest::Test
  def setup
    @tic_tac_toe = TicTacToe.new
  end

  def test_raises_if_cell_occupied
    @tic_tac_toe.move('X', 0, 0)
    assert_raises(ArgumentError) do
      @tic_tac_toe.move('X', 0, 0)
    end
    
    @tic_tac_toe.move('O', 1, 0)
  end

  def test_raises_on_bad_row_col
    [
      10, -1, 14, nil, 99, 10_000, 9.9
    ].sample(2) do |row, col|
      assert_raises(ArgumentError) do
        @tic_tac_toe.move('X', row, col)
      end
    end
  end

  def test_all_cells_occupied_game_completed
    [
      ['O','X', 'O'],
      ['O','X', 'X'],
      ['X','O', 'X']
    ].each_with_index do |a,i|
      a.each_with_index do |token,j|
        @tic_tac_toe.move(token, i, j)
      end
    end
    assert @tic_tac_toe.completed?
  end

  def test_horizontal_win
    3.times do |i|
      @tic_tac_toe.move('X', 0, i)
    end
    assert @tic_tac_toe.completed?
    # next move generate RuntimeError - game completed
    assert_raises(RuntimeError) do
      @tic_tac_toe.move('X', 0, 0)
    end
    
  end

  def test_vertical_win
    3.times do |i|
      @tic_tac_toe.move('X', i, 0)
    end
    assert @tic_tac_toe.completed?

    # next move generate RuntimeError - game completed
    assert_raises(RuntimeError) do
      @tic_tac_toe.move('X', 0, 0)
    end
  end

  def test_diagonal_win_left_to_right
    assert !@tic_tac_toe.completed?
    token_a = [
      [0,0],
      [1,1],
      [2,2]
    ].each {|row, col| @tic_tac_toe.move('X', row, col)}

    assert @tic_tac_toe.completed?
    
    # next move generate RuntimeError - game completed
    assert_raises(RuntimeError) do
      @tic_tac_toe.move('X', 0, 0)
    end
  end

  def test_diagonal_win_right_to_left
    assert !@tic_tac_toe.completed?
    token_a = [
      [0,2],
      [1,1],
      [2,0]
    ].each {|row, col| @tic_tac_toe.move('X', row, col)}

    assert @tic_tac_toe.completed?
    
    # next move generate RuntimeError - game completed
    assert_raises(RuntimeError) do
      @tic_tac_toe.move('X', 0, 0)
    end
  end

  def test_game_display
    [
      ['X', 0,0],
      ['O', 0,1],
      ['X', 1,1],
      ['O', 1,2],
      ['X', 2,2]
    ].each {|token, row, col| @tic_tac_toe.move(token, row, col)}
    
    assert_equal <<-EOS.chomp, @tic_tac_toe.to_s
X|O| 
-+-+-
 |X|O
-+-+-
 | |X
EOS
  end
end
