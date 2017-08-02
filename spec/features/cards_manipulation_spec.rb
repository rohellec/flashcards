require 'rails_helper'

feature "Manipulating cards" do
  given!(:user) { create(:user) }
  given!(:deck) { create(:deck, user: user) }
  given!(:first_card)  { create(:card, deck: deck) }
  given!(:second_card) { create(:card, original_text: "World",
                                       translated_text: "Мир",
                                       deck: deck) }

  background do
    login(user.email, "foobar")
    visit cards_path
  end

  context "Index" do
    scenario "doesn't have link for adding card if current deck isn't chosen" do
      expect(page).not_to have_content("Добавить карточку")
    end

    scenario "lists all user's cards" do
      user.cards.each do |card|
        expect(page).to have_content(card.original_text)
      end
    end
  end

  context "Adding card" do
    context "from deck's show page" do
      background do
        visit deck_path(deck)
        click_link("Добавить карточку")
        fill_in "Оригинал", with: "Bye"
        fill_in "Перевод",  with: "Пока"
      end

      include_examples "cards is added to deck"
    end

    context "from decks index page" do
      background do
        visit decks_path
        click_link "Добавить карточку", href: new_deck_card_path(deck)
        fill_in "Оригинал", with: "Bye"
        fill_in "Перевод",  with: "Пока"
      end

      include_examples "cards is added to deck"
    end

    context "to the current deck" do
      background do
        visit decks_path
        click_link "Выбрать"
        within("ul.nav") { click_link "Добавить карточку" }
        fill_in "Оригинал", with: "Bye"
        fill_in "Перевод",  with: "Пока"
      end

      include_examples "cards is added to deck"
    end
  end

  scenario "Show displays selected card" do
    click_link("Показать", href: card_path(first_card))
    expect(page).to have_current_path(card_path(first_card))
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
      visit deck_path(deck)
      expect(page).not_to have_content(first_card.original_text)
    end
  end
end
