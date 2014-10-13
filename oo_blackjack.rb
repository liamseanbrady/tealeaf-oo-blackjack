# PLUG-IN - - - PLUG-IN - - - PLUG-IN - - - PLUG-IN - - - PLUG-IN - - - PLUG-IN - - - PLUG-IN - - - PLUG-IN - - - 

# Problem scope:

# Build an object-oriented blackjack game, for two players.

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

  def deal(hand, number)
    number.times do
      hand << @cards.pop
    end
  end

  def to_s
    @cards.each{ |card| puts "#{card}" }
  end
end

class Player
  attr_reader :name, :hand

  def initialize(name, hand)
    @name = name
    @hand = hand
  end
end

class Human < Player
  def initialize(name, hand)
    super(name, hand)
  end
end

class Dealer < Player
  def initialize(name, hand)
    super(name, hand)
  end

  def shuffle(cards)
    cards.shuffle!
  end
end

class Blackjack
  def initialize
    @human = Human.new("Liam", [])
    @dealer = Dealer.new("Mr. Dealer", [])
    @deck = DeckFactory.new.create_deck
  end

  def play
    @dealer.shuffle(@deck.cards)
    @deck.deal(@human.hand, 2)
    @deck.deal(@dealer.hand, 2)
    blackjack_check(@human)
  end

  def blackjack_check(player)
    if calculate_total(player) == 21
      puts "#{player.name} got blackjack!"
      exit
    end
  end

  def calculate_total(player)
    total = 0
    values = player.hand.map{ |card| card.value }
    values.each do |val|
      if val == "A"
        total <= 10 ? total += 11 : total += 1
      elsif val.to_i == 0
        total += 10
      else
        total += val.to_i
      end
    end
    total
  end
end

blackjack = Blackjack.new.play















# Should begin the blackjack game
# Should deal 2 cards to player
# Should allow player to have 'hand' of cards
# Cards should be shuffled by dealer
# Should allow deck to deal cards to all players.
# Should calculate total value of human's cards
# Should get prompt from dealer for any player in the game to hit or stay
# Should allow players to make decision of whether to hit or stay




