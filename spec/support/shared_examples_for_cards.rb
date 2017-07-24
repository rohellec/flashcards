require 'rails_helper'

shared_examples "cards is added to deck" do
  scenario "increases cards count" do
    expect { click_button("Сохранить") }.to change(Card, :count).by(1)
  end

  scenario "appends it to the selected deck's cards list" do
    click_button("Сохранить")
    visit deck_path(deck)
    expect(page).to have_content("Bye")
  end
end
