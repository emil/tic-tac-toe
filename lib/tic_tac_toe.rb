class TicTacToe
  
  def initialize
    @grid = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  # Game move, token 'X' or 'O' at row, col
  # raises ArgumentError if cell is occupied
  # raises RuntimetError when move is attempted on completed game
  def move(token, row, col)
    raise RuntimeError, 'Game Completed.' if completed?

    validate_arguments(token, row, col)
    
    raise ArgumentError, "Cell #{row}, #{col} played already." unless @grid[row][col].nil?
    @grid[row][col] = token
  end

  # Game completed
  # when all the cells have been occupied
  # or there is a winner
  def completed?
    return true if all_cells_used?

    !winner.nil?
  end

  # winner 'X', 'O' or none (nil)
  def winner
    horizontal_winner ||
      vertical_winner ||
      diagonal_winner
  end

  # A string representation of the game
  # For example :
  # X| |
  # -+-+-
  #  |X|
  # -+-+-
  #  | |X
  # 
  def to_s
    lines = @grid.map do |row|
      row.map {|e| e.nil? ? ' ' : e }.join '|'
    end
    
    line_divider = ['-', '-', '-'].join '+'
    
    [
      lines.first,
      line_divider,
      lines[1],
      line_divider,
      lines.last
    ].join "\n"
  end

  private

  def all_cells_used?
    3.times do |i|
      return false if @grid[i].any? {|e| e.nil?}
    end
    
    true
  end

  def horizontal_winner
    # horizontal check rows
    @grid.each do |row|
      return row.first if is_win?(row)
    end
    nil
  end

  def vertical_winner
    3.times do |i|
      token_a = []
      3.times do |j|
        token_a << @grid[j][i]
      end
      return token_a.first if is_win?(token_a)
    end
    nil
  end


  def diagonal_winner
    # top/left to right/bottom diagonal
    token_a =
      [
        [0,0],
        [1,1],
        [2,2]
      ].collect {|row, col| @grid[row][col]}

    return token_a.first if is_win?(token_a)
    
    # right/top to left/bottom diagonal
    token_a =
      [
        [0,2],
        [1,1],
        [2,0]
      ].collect {|row, col| @grid[row][col]}

    return token_a.first if is_win?(token_a)
    nil
  end

  # whether an array is a 'win'
  # every element is populated with the the same kind
  def is_win?(a)
    a.all? {|e| !e.nil?} && a.uniq.size == 1
  end

  def validate_arguments(token, row, col)
    raise ArgumentError, "Invalid row #{row}" unless [0,1,2].include?(row)
    raise ArgumentError, "Invalid column #{col}" unless [0,1,2].include?(col)
    raise ArgumentError, "Invalid token '#{token}'" unless ['X', 'O'].include?(token)
  end
end
