require 'rails_helper'

describe DecksHelper do
  include Sorcery::TestHelpers::Rails::Controller

  let(:user) { create(:user_with_cards) }
  let(:deck) { create(:deck, user: user) }

  before { login_user(user) }

  describe "current_deck" do
    it "is nil by default" do
      expect(helper.current_deck).to be_nil
    end

    it "equals to selected deck after it was chosen" do
      user.switch_deck(deck)
      expect(helper.current_deck).to eq(deck)
    end
  end

  describe "current_cards" do
    it "equals to all user's cards if no deck is selected" do
      expect(helper.current_cards).to eq user.cards
    end

    it "equals to cards from current deck when it's selected" do
      user.switch_deck(deck)
      expect(helper.current_cards).to eq deck.cards
    end
  end
end
