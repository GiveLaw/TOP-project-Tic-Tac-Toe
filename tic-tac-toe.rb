class Player
  attr_accessor :name, :game, :sigil, :ai

  @@names = ['Popeye', 'Lancelot', 'Charlie', 'Django', 'Ruby',
            'Guinevere', 'Brutus', 'Anya', 'Dennis', 'Bugs']

  def initialize
  end

  def set_name
    print "
    Please, type a name or a nickname [randomize the name]:
    "
    @name = gets.chomp.empty? ? @@names.sample : $_.chomp.capitalize
    @name
  end

  def set_sigil
    loop do
      print "
    Choose a sigil ['']:
      1 - 
      2 - 
      "
      @sigil = gets.chomp.to_i == 2 ? '' : ''

      break if $_.to_i.between?(0, 2)

      puts "#{' ' * 8}Wrong input, the accepted values are 1 and 2 ..."
    end
    puts "#{' ' * 4}The #{@sigil} will be your symbol"
  end
  @sigil
end

class TicTacToe
  attr_accessor :player_x, :player_o
  attr_reader :winner, :current_turn, :vs_ai
  def initialize
    @grid = Array.new(3) {Array.new(3, ' ')}  # immutable array of mutable objects, https://www.theodinproject.com/lessons/ruby-nested-collections#creating-a-new-nested-array
    @player_names = ["Computer"]
    @available_sigils = ['', '']
    @available_spaces = [
                          [1, 1], [1, 2], [1, 3],
                          [2, 1], [2, 2], [2, 3],
                          [3, 1], [3, 2], [3, 3]
                        ]
  end

  def play
    puts "The game has started!"
    sleep 0.5
    #@current_turn = [@player_x, @player_o].sample unless @current_turn  # fail-safe
    9.times do
      system 'clear'  # - this works for Linux, probably for Windows:  system 'cls'
      puts get_info
      break if @winner

      if @current_turn.ai
        sleep 1.5
        # index_x = rand(1..3)
        # index_y = rand(1..3)

        #indexes = [rand(1..3), rand(1..3)]
        indexes = @available_spaces.sample
      else
        loop do
          # print "\n#{' ' * 6}Type the 𝙭 index: "
          # index_x = gets.to_i
          # print "\n#{' ' * 6}Type the 𝙮 index: "
          # index_y = gets.to_i
          # break if index_x.between?(1, 3) && index_y.between(1, 3) &&
          #           @available_spaces.include?([index_x, index_y])
  
          puts "\n#{' ' * 6}Type the indexes (x and y) separated by a space"
          indexes = gets.split.map {|i| i.to_i}
          break if indexes.count == 2 &&
                    indexes.all? {|i| i.between?(1, 3)} &&
                    @available_spaces.include?(indexes)
          puts "#{' ' * 8}Please enter correct values"
          puts "
          You can be guided by this:
      
          𝙭  🡢 🡪 🡲 🡺 🢂
        𝙮     1   2   3
    
        🡣 1     │   │  
        🡫    ───┼───┼───
        🡳 2     │   │  
        🡻    ───┼───┼───
        🢃 3     │   │  

        #{get_info}
          " unless indexes.all? {|i| i.between?(1, 3)}
        end
      end

      # @grid[index_y - 1][index_x - 1] = @current_turn.sigil
      # @grid[indexes[1]-1][indexes[0]-1] = @current_turn.sigil

      # To be more precise:
      index_y = indexes[1] - 1
      index_x = indexes[0] - 1
      
      @grid[index_y][index_x] = @current_turn.sigil

      @available_spaces.delete indexes

      check_play(@current_turn, [index_y, index_x])

      change_turn
    end

    if @winner
      puts "The winner is: #{@winner.name}, Congratulations! :)"
    else
      puts "huh! let me see, something is not right, apparently..."
      @winner = get_winner
      puts @winner ? "The winner is #{@winner}!" : 'No winner! :('
    end

    puts get_info
      
  end

  # Setters:
  def set_player(ai = false)
    player = Player.new

    if ai
      puts "#{' ' * 4}This is my chance!"
      player.sigil = @available_sigils.sample
      player.name = 'Computer'
      player.ai = true
      puts "#{' ' * 6}My name will be #{player.name} and my sigil will be #{player.sigil}"
    else
      if @available_sigils.count > 1
        player.set_sigil
      else
        player.sigil = @available_sigils[0]
      end
  
      loop do
        player.set_name
  
        break unless @player_names.include? player.name
  
        puts "#{' ' * 6}This name has been reserved for me •_•" if player.name== 'Computer'
  
        puts "#{' ' * 6}That name was taken!, please choose another one :)"
      end
      puts "#{' ' * 6}Your name is #{player.name} and your sigil will be #{player.sigil}"
    end
    @available_sigils.delete player.sigil
    @player_names.append player.name

    player.game = self  # object relationship

    player.sigil == '' ? @player_x = player : @player_o = player
  end

  def game_mode
    loop do
      print "
    Choose the game mode <type the number> [Single-player]:
      1 - Single-player (vs me, an AI :) )
      2 - Multiplayer 1 vs 1
      "

      # gets.chomp.to_i == 1 ? @vs_ai = true : @vs_ai = false
      @vs_ai = true if gets.chomp.to_i == 1 || $_.to_i == 0

      break if $_.to_i.between?(0, 2)

      puts "#{' ' * 8}Wrong input, the accepted values are 1 and 2"
    end
    game_mode = @vs_ai ? 'Single-player' : 'Multiplayer'
    puts "#{' ' * 6}Great! you're going to play #{game_mode}"
    game_mode
  end

  def goes_first
    loop do
      print "
    Choose who goes first <type the number>:
      1 : sigil: #{@player_o.sigil} - #{@player_o.ai ? 'Me' : 'Human'} -> #{@player_o.name}
      2 : sigil: #{@player_x.sigil} - #{@player_x.ai ? 'Me' : 'Human'} -> #{@player_x.name}
    "

      @current_turn = gets.to_i == 1 ? @player_o : @player_x

      break if $_.to_i.between?(1, 2)
      p "#{' ' * 8}Wrong input, the accepted values are 1 and 2"
    end
    p "#{' ' * 6}Okay! your choice was #{$_.chomp.empty? ? '-default-' : $_.to_i}, so #{@current_turn} goes_first"
  end

  private

  def change_turn
    @current_turn = @current_turn == player_o ? player_x : player_o
  end

  def check_play(player, indexes)
    @winner = player if @grid[indexes[0]].all? {|i| i == player.sigil}
    @winner = player if @grid.all? {|r| r[indexes[0]] == player.sigil}

    # special treatment for diagonals
    same_index = indexes[0] == indexes[1]
    #diagonal? = true if same_index
    for i in (0..2)
          diagonal = @grid[i][i] == player.sigil
          break unless diagonal
    end if same_index
    @winner = player if diagonal
    #also for diagonals:
    @winner = player if [@grid[0][2], @grid[1][1], @grid[2][0]].all? {|i| i == player.sigil}
  end

  def get_grid
    @grid.map {|row| (' ' * 8) + row.join(' │ ')}.join("\n" + ' ' * 7 + '───┼───┼───' + "\n") # it works but I could improve the code...
  end

  def get_winner  # fail-safe :)
    winner = nil
    #['', '']
    [@player_x, @player_o].each do |p|
      # rows and columns:
      winner = p if @grid.some? {|r| r.all? {|i| i == p.sigil}}
      winner = p if 3.times {|n| @grid.all? {|r| r[n] == p.sigil}}
      # diagonals:
      winner = p if [@grid[0][2], @grid[1][1], @grid[2][0]].all? {|i| i == p.sigil}
      winner = p if [@grid[0][0], @grid[1][1], @grid[2][2]].all? {|i| i == p.sigil}
    end
    winner
  end

  def get_info
    "
    Here is the info of #{self}
    Players:
      x - #{@player_x.ai ? 'Computer' : 'Human'} -> #{@player_x.name}
      o - #{@player_o.ai ? 'Computer' : 'Human'} -> #{@player_o.name}

    Current:\n\n#{get_grid}
    "
  end
end


# ---------------------------------------------------------------------------
# start message:

puts "
    Hey there!
    Its a Tic Tac Toe game!
    I hope you know the game, otherwise you can visit this link:
      https://en.wikipedia.org/wiki/Tic-tac-toe


      𝙭  🡢 🡪 🡲 🡺 🢂
    𝙮     1   2   3

    🡣 1     │   │  
    🡫    ───┼───┼───
    🡳 2     │   │  
    🡻    ───┼───┼───
    🢃 3     │   │  

    Here the numbers are the indexes, which you should use to choose the location of your mark:
    i.e. if you input:
          1 2
          * The first number represents the x-index and the second represents the y-index
    the program will put your mark in that position:

       │   │  
    ───┼───┼───
      │   │  
    ───┼───┼───
       │   │  


    These are the available symbols:
     instead of the x which might look ugly being a simple x/X
     instead of the circle which might not look good being an o/O or a zero (0)


    Okay, lets start!!

    *Please use a mono-space font family or similar, otherwise, it may look bad.

    IMPORTANT!!
    You can press enter to leave the default value if it has (it will appear in square brackets):
    Choose your sigil []     <-  is the default value here!
    Choose your sigil         <- this doesn't have a default value!
    "

# ---------------------------------------------------------------------------

game = TicTacToe.new

game.game_mode

puts "\n\n#{' ' * 3} Set the first profile: "
if game.vs_ai
  game.set_player  # false
  sleep 2
  puts "\n#{' ' * 3} My turn!"
  game.set_player ai = true  # to clarify that this is an AI ;)
else
  game.set_player  # false
  puts "\n#{' ' * 3} Set the second profile: "
  game.set_player  # false
end

sleep 1
game.goes_first

game.play
