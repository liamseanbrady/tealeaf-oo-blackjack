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
      break if total <= 21
      total -= 10
    end

    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > 21
  end

  def blackjack?
    cards.size == 2 && total == 21
  end

  def latest_card
    cards.last
  end
end

class Player
  include Hand
  attr_accessor :name, :cards

  def initialize(n)
    @name = n
    @cards = []
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

  def to_s
    "#{name}'s hand total is #{cards.total}"
  end
end

class Game
  attr_reader :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new("Ingin")
    @dealer = Dealer.new
  end

  def play
    2.times do
      player.add_card(deck.deal_one)
      dealer.add_card(deck.deal_one)
    end
    dealer.display_hand
    player.display_hand
    if player.blackjack? 
      "Blackjack! #{player.name} won!"
      exit
    end
    player_turn
    if dealer.blackjack? 
      "Blackjack! #{dealer.name} won!"
      exit
    end
    dealer_turn
    display_winner
  end

  def player_turn
    begin
      puts "Hit or Stay? (h/s)"
      decision = gets.chomp.downcase
      if decision == "h"
        player.add_card(deck.deal_one)
        puts "You got #{player.latest_card}"
        player.display_hand
        if player.is_busted?
          puts "#{player.name} went bust and lost!"
          exit
        end
      end
    end until decision != "h"
  end

  def dealer_turn
    begin
      dealer.add_card(deck.deal_one)
      puts "#{dealer.name}'s card was #{dealer.latest_card}"
      dealer.display_hand
      if player.is_busted?
        puts "#{dealer.name} went bust. #{player.name} won!"
        exit
      end
    end until dealer.total >= 17
  end

  def display_winner
    if player.total == dealer.total
      puts "It's a tie"
    elsif player.total > dealer.total
      puts "#{player.name} won!"
    else
      puts "#{dealer.name} won!"
    end
  end
end

game = Game.new.play









