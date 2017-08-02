require 'rails_helper'

feature "Attaching picture to card" do
  given!(:user) { create(:user) }
  given!(:deck) { create(:deck, user: user) }

  background do
    login(user.email, "foobar")
    switch_deck(deck)
    click_link("Добавить карточку", match: :first)
    fill_in "Оригинал", with: "Test"
    fill_in "Перевод",  with: "Тест"
  end

  context "with empty file and url fields" do
    scenario "shows default picture" do
      click_button("Сохранить")
      expect(page).to have_css("img[src*='missing.png']")
    end
  end

  context "using file field" do
    context "of invalid large size" do
      background do
        attach_file("card_picture", "#{Rails.root}/spec/fixtures/test-large.jpeg")
        click_button("Сохранить")
      end

      scenario "generates error" do
        expect(page).to have_css(".alert-danger")
      end
    end

    context "of valid normal size" do
      background do
        attach_file("card_picture", "#{Rails.root}/spec/fixtures/test-normal.jpeg")
        click_button("Сохранить")
      end

      scenario "shows uploaded picture" do
        expect(page).to have_css("img[src*='normal.jpeg']")
      end
    end
  end

  context "using url field" do
    given!(:url) { "https://s3.eu-central-1.amazonaws.com/dr-flashcards/images/cards/pictures/test.png" }

    background do
      fill_in "card_picture_remote_url", with: url
      click_button("Сохранить")
    end

    scenario "shows uploaded test" do
      expect(page).to have_css("img[src*='test.png']")
    end
  end
end
