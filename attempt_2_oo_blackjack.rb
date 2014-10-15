# Requirements:

# 1. Blackjack is a card game which involves a dealer and players.
# 2. Each player and the dealer is dealed two cards to begin with from a deck of 52 cards (4 suits). Cards: 4 * (2-10), 4 * (J, K, Q), 4 * (A)) = 52
# 3. If player gets blackjack, then the player who gets blackjack has won, and the game ends immediately.
# 4. Each player gets a chance to hit or stay. If the total of their hand goes above 21 at any point, they go bust and lose.
# 5. If the dealer gets blackjack and no player gets blackjack then the dealer wins and the game ends immediately.
# 6. Or else if the dealer's hand total is less than 17, the dealer must keep 'hit'-ing  until their score is above 17.
# 7. Compare scores of all players and dealer. The highest score wins.

# Nouns: Card, Dealer, Player, Deck, Suit, Game, Blackjack, 
# Constants: 17, 21, 1 (NUMBER_OF_DECKS)
# States: blackjack?, dealer threshold?, bust?
# Verbs: deal, begin, end,_game, hit, stay, lose, compare

# PLUG-IN - - - PLUG-IN - - - PLUG-IN - - - PLUG-IN - - - PLUG-IN - - - PLUG-IN - - - PLUG-IN - - - PLUG-IN - - - 

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
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def shuffle_cards
    @cards.shuffle!
  end

  def deal(hand, number)
    number.times do
      hand << @cards.pop
    end
  end

  def to_s
    @cards.each{ |card| puts "#{card}" }
  end
end

class Hand
  attr_reader :owner, :cards

  def initialize(owner, cards)
    @owner = owner
    @cards = cards
  end

  def blackjack?
    self.total == 21
  end

  def total
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
    total
  end

  def latest_card
    @cards.last
  end

  def to_s
    cards.each{ |card| puts card }
  end
end

class Blackjack
  def initialize
    @deck = DeckFactory.new.create_deck
    @human_hand = Hand.new("Ingin", [])
    @dealer_hand = Hand.new("Mr. Dealer", [])
  end

  def play
    @deck.shuffle_cards
    @deck.deal(@human_hand.cards, 2)
    @deck.deal(@dealer_hand.cards, 2)
    puts @human_hand.blackjack?
    self.player_hit_or_stay
    puts @dealer_hand.blackjack?
    self.dealer_hit
    self.compare_hands
  end

  def dealer_hit
    loop do
      @deck.deal(@dealer_hand.cards, 1)
      puts "#{dealer_hand.owner}'s card was #{@dealer_hand.latest_card}"
      if @dealer.total > 21
        puts "Game over! #{@dealer_hand.owner} busted... You won!"
      end
    end until @dealer_hand.total >= 17
  end

  def player_hit_or_stay
    puts "#{@human_hand.owner}, would you like to hit or stay?"
    begin
      decision = gets.chomp
      if decision.downcase == "h"
        @deck.deal(@human_hand.cards, 1)
        puts "The card was #{@human_hand.latest_card}"
      end
      if @human_hand.total > 21
        puts "Game over! You busted... You lost!"
        exit
      end
    end until decision.downcase != "h"
  end
end

blackjack = Blackjack.new.play


# Deck should be shuffled before cards are dealt
# Should deal 2 cards to first hand
# Should deal 2 cards to second hand
# Should find out if first hand has blackjack
# Should find out if first hand owner wishes to hit or stay
# Should bust player if their hand is over 21
# Should keep hit-ting for dealer until total >= 17
# Compare the scores of the human and the dealer








