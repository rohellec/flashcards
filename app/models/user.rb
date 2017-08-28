class User < ApplicationRecord
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end
  before_save { email.downcase! }

  has_many :authentications, dependent: :destroy
  has_many :decks, dependent: :destroy
  has_many :cards, through: :decks

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d]+(\.[a-z\d]+)?\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 },
                       confirmation: true, if: -> { new_record? || changes[:crypted_password] }

  class << self
    def with_cards_for_review
      joins(:decks, :cards).where("? >= review_date", Date.current).distinct
    end
  end

  def cards_for_review
    (current_deck ? current_deck.cards : cards).for_review
  end

  def current_deck
    decks.find_by(id: current_deck_id)
  end

  def switch_deck(deck)
    result = deck.id if decks.find(deck.id) && deck != current_deck
    update(current_deck_id: result)
  end
end
