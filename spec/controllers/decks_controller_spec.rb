require 'rails_helper'

describe DecksController do
  include Sorcery::TestHelpers::Rails::Controller

  let(:user) { create(:user, email: "foo@bar.com", password: "foobar") }
  let(:deck) { create(:deck, user: user) }
  let(:other_user) { create(:user) }

  context "when not logged in" do
    it "redirects patch" do
      patch :update, params: { id: deck.id, deck: { name: deck.name } }
      expect(response).to redirect_to(login_url)
    end
  end

  context "when logged in as wrong user" do
    before { login_user(other_user) }

    it "raises the error" do
      expect do
        patch :update, params: { id: deck.id, deck: { name: deck.name } }
      end.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  context "before index" do
    before do
      login_user(user)
      get :index
    end

    it "stores request url in a session for cards_back_url" do
      expect(session[:card_back_url]).to eq(decks_url)
    end
  end
end
