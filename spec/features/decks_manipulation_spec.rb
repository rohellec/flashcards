require 'rails_helper'

feature "Manipulating decks" do
  given!(:user) { create(:user) }
  given!(:deck) { create(:deck_with_cards, name: "First", user: user) }
  given!(:other_deck) { create(:deck_with_cards, name: "Last", user: user) }

  background do
    visit decks_path
    login(user.email, "foobar")
  end

  context "Index" do
    scenario "lists all user's decks" do
      user.decks.each do |deck|
        expect(page).to have_content(deck.name)
      end
    end

    context "when current deck is not chosen" do
      scenario "there is no link in the header" do
        expect(page).not_to have_css("ul.nav>li>a", text: "Добавить карточку")
      end

      scenario "there is no deck marked as current" do
        expect(page).not_to have_content("Текущая")
      end
    end

    context "when current deck is chosen" do
      background { click_link "Выбрать", href: switch_deck_path(deck) }

      scenario "there is a link in the header" do
        expect(page).to have_css("ul.nav>li>a", text: "Добавить карточку")
      end

      scenario "there is a deck marked as current" do
        expect(page).to have_content("Текущая")
      end
    end
  end

  context "Show page" do
    background { click_link("Карточек: #{deck.cards.count}", href: deck_path(deck)) }

    scenario "displays selected deck" do
      expect(page).to have_content(deck.name)
    end

    scenario "lists all cards for selected deck" do
      deck.cards.each do |card|
        expect(page).to have_content(card.original_text)
      end
    end

    scenario "doesn't list cards from other decks" do
      other_deck.cards.each do |card|
        expect(page).not_to have_content(card.original_text)
      end
    end
  end

  context "Adding deck" do
    background do
      click_link("Добавить колоду")
      fill_in "deck_name", with: "Последнее"
    end

    scenario "increases decks count" do
      expect { click_button("Сохранить") }.to change(Deck, :count).by(1)
    end

    scenario "appends it to current user's decks list" do
      click_button "Сохранить"
      visit decks_path
      expect(page).to have_content("Последнее")
    end
  end

  context "Updating deck" do
    background do
      click_link("Поправить", href: edit_deck_path(deck))
      fill_in "deck_name", with: "Новые слова"
      click_button "Сохранить"
    end

    scenario "redirects to deck's show page" do
      expect(page).to have_current_path(deck_path(deck))
    end

    scenario "changes deck's field" do
      deck.reload
      expect(deck.name).to eq("Новые слова")
    end
  end

  context "Destroying deck" do
    scenario "decreases decks count" do
      expect { click_link("Удалить", href: deck_path(deck)) }.to change(Deck, :count).by(-1)
    end

    scenario "removes it from current user's decks list" do
      click_link("Удалить", href: deck_path(deck))
      visit decks_path
      expect(page).not_to have_content(deck.name)
    end
  end
end
