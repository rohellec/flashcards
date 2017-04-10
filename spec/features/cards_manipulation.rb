require 'rails_helper'

feature "Manipulating cards" do
  given!(:user) { create(:user) }
  given!(:first_card)  { create(:card, user: user) }
  given!(:second_card) { create(:card, original_text: "World",
                                       translated_text: "Мир",
                                       user: user) }

  background do
    visit cards_path
    login(user.email, "foobar")
  end

  scenario "Index lists all user's cards" do
    user.cards.each do |card|
      expect(page).to have_content(card.original_text)
    end
  end

  scenario "Show displays selected card" do
    click_link("Показать", href: card_path(first_card))
    expect(page).to have_current_path(card_path(first_card))
  end

  context "Adding card" do
    background do
      click_link("Добавить карточку")
      fill_in "Оригинал", with: "Bye"
      fill_in "Перевод",  with: "Пока"
    end

    scenario "increases cards count" do
      expect { click_button("Сохранить") }.to change(Card, :count).by(1)
    end

    scenario "appends it to current user's cards list" do
      click_button("Сохранить")
      visit cards_path
      expect(page).to have_content("Bye")
    end
  end

  context "Updating card" do
    background do
      click_link("Редактировать", href: edit_card_path(first_card))
      fill_in "Дата пересмотра", with: Date.yesterday
      click_button "Сохранить"
    end

    scenario "redirects to card's show page" do
      expect(page).to have_current_path(card_path(first_card))
    end

    scenario "changes card's fields" do
      first_card.reload
      expect(first_card.review_date).to eq(Date.yesterday)
    end
  end

  context "Destroying card" do
    scenario "decreases cards count" do
      expect { click_link("Удалить", href: card_path(first_card)) }.to change(Card, :count).by(-1)
    end

    scenario "removes it from current user's cards list" do
      click_link("Удалить", href: card_path(first_card))
      visit cards_path
      expect(page).not_to have_content(first_card.original_text)
    end
  end
end
