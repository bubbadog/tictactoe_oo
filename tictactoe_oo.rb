=begin 
A game played by two people on a board of 3x3 squares (grid).
Start with board empty with one player being X and th other O, respectively.
The players alternate with the X player going first, and each subsequent
round the players choose from the empty aquares.  The game proceeds
this way until a player wins by getting 3 in a row or in a tie (if the 
board's squares are all marked).
=end

require 'pry'


class Board
  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9],[3,5,7]]
  def initialize
    @data = {}                # creating the data structure for the board
    (1..9).each {|position| @data[position] = Square.new(' ')}  # initializing new square object and passing ' ' as it's value
  end

  def draw_board
    system 'clear'
    puts
    puts " 1    |2    |3"
    puts "   #{@data[1]}  |  #{@data[2]}  |  #{@data[3]} "
    puts "      |     |"
    puts " -----+-----+-----"
    puts " 4    |5    |6"
    puts "   #{@data[4]}  |  #{@data[5]}  |  #{@data[6]} "
    puts "      |     |"
    puts " -----+-----+-----"
    puts " 7    |8    |9"
    puts "   #{@data[7]}  |  #{@data[8]}  |  #{@data[9]} "
    puts "      |     | "
    puts
  end

  def empty_positions
    @data.select {|_, square| square.empty?}.keys   # use our .empty inst. method (Class Square) to find keys (.keys) of square objects with value = ' '
  end                                               # .select returns array of keys (e.g. [2,5,7]) of avail squares

  def empty_squares
    @data.select {|_, square| square.empty?}.values # .values returns [] of squares [square1, square3,..etc] (not hash as .select does)
  end

  def mark_square(position, marker)    # marks square with selected position and player/comp marker (X/O)
    @data[position].mark(marker)       # puts marker (X or O) in data{} value position
  end

  def all_squares_marked?              # returns boolean
    empty_squares.size == 0
  end

  def three_squares_in_row?(marker)
    WINNING_LINES.each do |line|    # iterates through each of 7 possible winning lines to see if one array has all 3 squares with only X or O (to win)
      return true if @data[line[0]].value == marker && @data[line[1]].value == marker &&
      @data[line[2]].value == marker
    end
    false
  end

end

class Player
  attr_reader :name, :marker # sets getter method for player object (passed in from Game's initialize method)
  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

class Square              # will pass square objects into @data (to allocate positions on board)
  attr_reader :value      # getter for value (X or O) in the square object
  def initialize(value)   # setting instance variable (@value) for square
    @value = value 
  end  

  def mark(marker)        # Instance method to set @ value to marker passed in from player (X or O)
    @value = marker
  end

  def occupied?           # getter - returns boolean (T if not ' ')
    @value != ' '
  end

  def empty?
    @value == ' '          # getter - converse of occupied? inst method
  end

  def to_s                # for string interpolation of board
    @value
  end
end

class Game                  # Game engine
  TIE = "It's a tie!"
  def initialize
    @board = Board.new
    @human = Player.new("You", "X")
    @computer = Player.new("HAL", "O")
    @current_player = @human   # @current_player begins with @human 1st
  end

  def current_player_marks_square   # method for putting player's mark (X/O) in square
    if @current_player == @human    # determines if player is not the computer
      begin
        puts "=> Pick a square from (#{@board.empty_positions.join(', ')})."
        position = gets.chomp.to_i  # sets person's choice of square
      end until @board.empty_positions.include?(position)
    else
      position = @board.empty_positions.sample
    end
    @board.mark_square(position, @current_player.marker)
  end

  def alternate_player             # instance method to alternate players
    if @current_player == @human
      @current_player = @computer
    else
      @current_player = @human
    end
  end

  def current_player_wins?          # check if criteria were met to win
    @board.three_squares_in_row?(@current_player.marker) # pass current players marker (X/O) to three_squares_in_row to check if won!
  end

  def play                         # game proceeds in this manner 
    @board.draw_board
    loop do 
      current_player_marks_square  # call to inst method to prompt and get players square selection
      @board.draw_board            # redraw board showing chosen square with player's mark (X/O)
      if current_player_wins?       # aftr board is drawn, need to check for winner
        puts "#{@current_player.name} dominated!"
        break
      elsif @board.all_squares_marked?
        puts TIE
        break
      else
        alternate_player
      end
    end
    puts "Adios!"
  end
end

game = Game.new.play
game


 