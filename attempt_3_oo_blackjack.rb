# What is Blackjack?

# - Game between 2-many players.
# - There is one dealer and the rest are players.
# - It's a card game which uses a standard deck of 52 cards.
# - Game starts with dealer dealing 2 cards to itself and 2 cards to each player.
# - If any player has a total of 21 (Blackjack) at this stage, they win and the game ends.
# - Otherwise, each player can keep asking for another card whilst their card total is under 21.
# - If their card total goes over 21, then they go bust and the game ends.
# - If the dealer's total is 21 (Blackjack) then it wins and the game ends.
# - Otherwise, the dealer must ask for a card until its total is 17 or greater.
# - If the dealer's total goes over 21 at any point, then the dealer is bust and the game ends.
# - Otherwise, compare the totals of the dealer and the player. The highest wins.

# Nouns: Game, Hand, DealerHand, PlayerHand, Deck

# Verbs: deal, win, end, ask, total

# States: bust?, blackjack?

# NOTES
# Game class should never know about the Card class.

require "pry"

module Blackjackable
  def blackjack?
    calculate_total == 21
  end

  def bust?
    calculate_total > 21
  end

  def calculate_total
    values = @cards.map{ |card| card.value }
    total = 0
    values.each do |value|
      if value == "A"
        total += 11
      elsif value.to_i == 0
        total += 10
      else
        total += value.to_i
      end
    end
    values.count("A").times do
      if total < 21
        break
      else
        total -= 10
      end
    end
    return total
  end
end

class DeckFactory
  def create_deck
    suits = ["D", "H", "C", "S"]
    values = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    cards = []
    deck = suits.each do |suit|
      values.each do |value|
        cards << Card.new(suit, value)
      end
    end
    Deck.new(cards)
  end
end

class Deck
  def initialize(cards)
    @cards = cards
  end

  def shuffle_cards
    @cards.shuffle!
  end

  def deal(hand, num_cards)
    num_cards.times do
      hand << @cards.pop
    end
  end

  def to_s
    @cards.each{ |card| puts card }
  end
end

class Card
  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "#{@suit}, #{@value}"
  end
end

class Hand
  include Blackjackable

  attr_reader :cards, :owner

  def initialize(owner, cards)
    @owner = owner
    @cards = cards
  end
end

class Game
  def initialize(deck_factory)
    @deck = deck_factory.create_deck
    @player_hand = Hand.new("Ingin", [])
    @dealer_hand = Hand.new("Dealer", [])
  end

  def play
    @deck.shuffle_cards
    @deck.deal(@player_hand.cards, 2)
    @deck.deal(@dealer_hand.cards, 2)
    puts "You got blackjack!" if @player_hand.blackjack?
    puts @player_hand.calculate_total
    @dealer_hand.calculate_total
    player_hit_or_stay
    puts "Dealer got blackjack!" if @dealer_hand.blackjack?
    dealer_hit
    puts @dealer_hand.calculate_total
    display_winner
  end

  def player_hit_or_stay
    begin
      puts "Hit or Stay? (h/s)"
      decision = gets.chomp
      if decision.downcase == "h"
        @deck.deal(@player_hand.cards, 1)
        puts @player_hand.cards
        if @player_hand.bust?
          puts "You went bust! You lose!"
          exit
        end
      end
    end until decision.downcase != "h"
  end

  def dealer_hit
    loop do
      @deck.deal(@dealer_hand.cards, 1)
      if @dealer_hand.bust?
        puts "Dealer went bust! You won!"
        exit
      end
    end until @dealer_hand.calculate_total >= 17
  end

  def display_winner
    if @player_hand.calculate_total == @dealer_hand.calculate_total
      puts "It's a tie!"
    elsif @player_hand.calculate_total > @dealer_hand.calculate_total
      puts "#{@player_hand.owner} won!"
    else
      puts "#{@dealer_hand.owner} won!"
    end
  end

end

deck_factory = DeckFactory.new
blackjack = Game.new(deck_factory).play

# Should start the game of blackjack
# Should create a deck of cards
# Should shuffle the deck of cards
# Should deal 2 cards to player_hand
# Should deal 2 cards to dealer_hand
# Should check for Blackjack condition
# Should check if dealer has blackjack
# Should allow dealer to hit
# Should make dealer hit until total >= 17
# Should compare hands and decide winner





