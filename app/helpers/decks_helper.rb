module DecksHelper
  def cards_for_review
    current_cards.for_review
  end

  def current_deck
    current_user.current_deck
  end

  def current_cards
    current_deck ? current_deck.cards : current_user.cards
  end
end
