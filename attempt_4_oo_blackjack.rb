# An object-oriented Blackjack game

# 1. Abstraction
# 2. Encapsulation

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    ["H", "D", "C", "S"].each do |suit|
      ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "K", "Q", "A"].each do |value|
        @cards << Card.new(suit, value)
      end
    end
    scramble!
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end

  def size
    cards.size
  end
end

class Card
  attr_reader :suit, :face_value

  def initialize(suit, face_value)
    @suit = suit
    @face_value = face_value
  end

  def pretty_output
    "The #{face_value} of #{find_suit}"
  end

  def to_s
    pretty_output
  end

  def find_suit
    ret_val = case suit
                when "H" then "Hearts"
                when "D" then "Diamonds"
                when "C" then "Clubs"
                when "S" then "Spades"
              end
    ret_val
  end
end

module Hand
  def initialize(cards)
    @cards = cards
  end

  def display_hand
    puts "- - - - - #{name}'s Hand - - - - -"
    cards.each{ |c| puts "=> #{c}" }
    puts "Total: #{total}"
  end

  def total
    face_values = cards.map{ |card| card.face_value }

    total = 0
    face_values.each do |val|
      if val == "A"
        total += 11
      else
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    face_values.select{ |val| val == "A" }.count.times do
      break if total <= Blackjack::BLACKJACK_AMOUNT
      total -= 10
    end

    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > Blackjack::BLACKJACK_AMOUNT
  end
end

class Player
  include Hand
  attr_accessor :name, :cards

  def initialize(n)
    @name = n
    @cards = []
  end

  def display_flop
    display_hand
  end

  def to_s
    "#{name}'s hand total is #{total}"
  end
end

class Dealer
  include Hand
  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end

  def display_flop
    puts "- - - - - Dealer's Hand - - - - -"
    puts "=> First card is hidden"
    puts "=> Second card is #{cards[1]}"
  end

  def to_s
    "#{name}'s hand total is #{cards.total}"
  end
end

class Blackjack
  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17

  attr_reader :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new("Player1")
    @dealer = Dealer.new
  end

  def set_player_name
    puts "What's your name?"
    player.name = gets.chomp
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def display_flop
    dealer.display_flop
    player.display_flop
  end

  def blackjack_or_bust?(p_or_d)
    if p_or_d.total == BLACKJACK_AMOUNT
      if p_or_d.is_a?(Dealer)
        puts "Sorry, Dealer got blackjack! #{player.name} loses!"
      else
        puts "Congratulations, #{player.name} hit blackjack! #{player.name} wins!"
      end
      play_again?
    elsif p_or_d.is_busted?
      if p_or_d.is_a?(Dealer)
        puts "Congratulations, Dealer busted! #{player.name} wins!"
      else
        puts "Sorry, #{player.name} busted. #{player.name} loses!"
      end
      play_again?
    end
  end

  def player_turn
    puts "#{player.name}'s turn"
    blackjack_or_bust?(player)
    while !player.is_busted?
      puts "What would you like to do? 1) Hit 2) Stay"
      response = gets.chomp
      if !["1", "2"].include?(response)
        puts "Error: you must enter 1 or 2"
        next
      end
      if response == "2"
        puts "#{player.name} chose to stay..."
        break
      end
      new_card = deck.deal_one
      puts "Dealing card to #{player.name}: #{new_card}"
      player.add_card(new_card)
      puts "#{player.name}'s total is now: #{player.total}"
      blackjack_or_bust?(player)
    end
    puts "#{player.name} stays at #{player.total}."
  end 

  def dealer_turn
    puts "Dealer's turn."
    blackjack_or_bust?(dealer)
    while dealer.total < DEALER_HIT_MIN
      new_card = deck.deal_one
      puts "Dealing card to dealer: #{new_card}"
      dealer.add_card(new_card)
      puts "Dealer total is now #{dealer.total}"
      blackjack_or_bust?(dealer)
    end
    puts "Dealer stays at #{dealer.total}."
  end

  def who_won?
    if player.total > dealer.total
      puts "Congratulations! #{player.name} wins!"
    elsif player.total < dealer.total
      puts "Sorry! #{player.name} loses!"
    else
      puts "It's a tie!"
    end
    play_again?
  end

  def play_again?
    puts ""
    puts "Would you like to play again? 1) Yes 2) No, exit"
    if gets.chomp == "1"
      puts "Starting new game..."
      puts ""
      reset
      start
    else
      puts "Goodbye!"
      exit
    end
  end

  def reset
    deck = Deck.new
    player.cards = []
    dealer.cards = []
  end

  def start
    set_player_name
    deal_cards
    display_flop
    player_turn
    dealer_turn
    who_won?
  end
end

game = Blackjack.new
game.start









