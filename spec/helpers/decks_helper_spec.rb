require 'rails_helper'

describe DecksHelper do
  include Sorcery::TestHelpers::Rails::Controller

  let(:user) { create(:user) }
  let(:deck) { create(:deck, user: user) }

  describe "current_deck" do
    before { login_user(user) }

    it "is nil by default" do
      expect(helper.current_deck).to be_nil
    end

    it "equals to selected deck after it was chosen" do
      user.switch_deck(deck)
      expect(helper.current_deck).to eq(deck)
    end
  end
end
