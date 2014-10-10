class Board
  attr_accessor :board_positions

  def initialize
    @board_positions = {}
    (1..9).each { |position| @board_positions[position] = ' ' }
  end

  def draw
    offset = 4
    draw_line('|', offset)
    draw_line('|', offset, board_positions[1], board_positions[2], board_positions[3])
    draw_line('|', offset)
    draw_line('-', offset + 1)
    draw_line('|', offset)
    draw_line('|', offset, board_positions[4], board_positions[5], board_positions[6])
    draw_line('|', offset)
    draw_line('-', offset + 1)
    draw_line('|', offset)
    draw_line('|', offset, board_positions[7], board_positions[8], board_positions[9])
    draw_line('|', offset)
  end

  def clear
    (1..9).each { |position| self.board_positions[position] = ' ' }
  end

  def check_winner
    winning_lines = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

    if get_empty_positions.size <= 4
      winning_lines.each do |line|
        return "Player" if board_positions.values_at(*line).count('X') == 3
        return "Computer" if board_positions.values_at(*line).count('O') == 3
      end
    end
    return nil
  end

  def get_empty_positions
    board_positions.select { |k, v| v != 'X' && v != 'O'}
  end

  protected
  
  def draw_line(dash, offset, row_cell_opt_1 = '', row_cell_opt_2 = '', row_cell_opt_3 = '')
    # dash:           what kind of character to draw (-, |, etc.) 
    # offset:         number of spaces for spacing dashes
    # row cell opts:  X or O if the cell is marked by HUMAN or COMPUTER
    #

    if dash == "-"
      filler = dash
    else
      filler = " "
    end

    line_str =  row_cell_opt_1.rjust(offset, filler) + dash.rjust(offset, filler) +
                row_cell_opt_2.rjust(offset, filler) + dash.rjust(offset, filler) + row_cell_opt_3.rjust(offset, filler)

    puts line_str
    line_str = ''
  end
end # class Board

class Player
  def initialize(n)
    @name = n
  end

  def place_piece(board, position = 0, value = 'O')
    positions = board.get_empty_positions

    if positions.keys.size == 0
      return false
    end

    if position == 0
      board.board_positions[positions.keys.sample] = value
    else
      board.board_positions[position] = value      
    end
    return true
  end

  def play_again?
    puts "Play again? [Y/N]"
    response = gets.chomp.upcase
    response == 'Y' ? true : false
  end
end

class TicTacToe
  attr_accessor :computer, :human, :board

  def initialize
    @computer = Player.new("Computer")
    @human = Player.new("Sam")
    @board = Board.new
  end

  def play
    begin
      board.clear
      board.draw
      while  board.get_empty_positions.size > 0
        begin
          puts "Choose a position #{board.get_empty_positions.keys} to place a piece:"        
          input = gets.chomp.to_i
        end until board.get_empty_positions.include?(input)

        human.place_piece(board, input.to_i, 'X')
        winner = board.check_winner
        if winner == 'Player'
          puts "Player won!"
          board.draw
          break
        end
        
        computer.place_piece(board)
        winner = board.check_winner
        if winner == 'Computer'
          puts "Computer won!"
          board.draw
          break
        end

        board.draw
      end # while
    end until (human.play_again? == false)
  end # play
end # class TicTacToe

ttt = TicTacToe.new
ttt.play