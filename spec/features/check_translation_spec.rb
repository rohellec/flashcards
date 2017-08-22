require 'rails_helper'

feature "Check card translation" do
  given(:user) { create(:user) }
  given(:deck) { create(:deck, user: user) }
  given(:card) { create(:card, deck: deck) }

  background do
    login(user.email, "foobar")
    card.update(review_date: Date.current)
    visit home_index_path
  end

  scenario "leaving original_text blank" do
    click_on "Проверить"
    expect(page).to have_content "введите оригинальный текст:"
  end

  scenario "filling original_text with wrong value" do
    wrong = card.original_text * 2
    fill_in "Оригинал", with: wrong
    click_on "Проверить"
    expect(page).to have_content "Не верно"
  end

  scenario "filling original_text with word with 2 typos" do
    typo = card.original_text.sub(/\w/, '\&\&\&')
    fill_in "Оригинал", with: typo
    click_on "Проверить"
    expect(page).to have_content "у Вас опечатка"
  end

  scenario "filling original_text with right value" do
    fill_in "Оригинал", with: card.original_text
    click_on "Проверить"
    expect(page).to have_content "Верно"
  end
end
