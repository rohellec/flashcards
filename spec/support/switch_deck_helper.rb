def switch_deck(deck)
  visit decks_path
  click_link "Выбрать", href: switch_deck_path(deck)
end
