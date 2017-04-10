require 'rails_helper'

feature "Check card translation" do
  given(:user) { create(:user) }
  given(:card) { create(:card, user: user) }

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
    wrong_val = card.original_text * 2
    fill_in "Оригинал", with: wrong_val
    click_on "Проверить"
    expect(page).to have_content "Не правильно"
  end

  scenario "filling original_text with right value" do
    fill_in "Оригинал", with: card.original_text
    click_on "Проверить"
    expect(page).to have_content "Правильно"
  end
end
