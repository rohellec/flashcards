require 'rails_helper'

describe CardsController do
  include Sorcery::TestHelpers::Rails::Controller

  let(:user) { create(:user, email: "foo@bar.com", password: "foobar") }
  let(:deck) { create(:deck, user: user) }
  let(:card) { create(:card, deck: deck) }
  let(:other_user) { create(:user) }

  context "when not logged in" do
    it "redirects patch" do
      patch :update, params: { id: card.id, card: { original_text: card.original_text } }
      expect(response).to redirect_to(login_url)
    end
  end

  context "when logged in as wrong user" do
    before { login_user(other_user) }

    it "raises the error" do
      expect do
        patch :update, params: { id: card.id, card: { original_text: card.original_text } }
      end.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  context "before index" do
    before do
      login_user(user)
      get :index
    end

    it "stores request url in a session for card_back_url" do
      expect(session[:card_back_url]).to eq(cards_url)
    end
  end

  context "action back" do
    before do
      login_user(user)
      session[:card_back_url] = nil
    end

    it "redirects to session's card_back_url value if it is set" do
      get :index
      get :back
      expect(response).to redirect_to(session[:card_back_url])
    end

    it "redirects to current_deck if it is set and there is no value in session[:card_back_url]" do
      user.switch_deck(deck)
      get :back
      expect(response).to redirect_to(deck_url(deck))
    end

    it "redirects to index in other cases" do
      get :back
      expect(response).to redirect_to(cards_url)
    end
  end
end
