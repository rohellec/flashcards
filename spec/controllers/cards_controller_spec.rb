require 'rails_helper'

describe CardsController do
  include Sorcery::TestHelpers::Rails::Controller

  let(:user) { create(:user, email: "foo@bar.com", password: "foobar") }
  let(:card) { create(:card, user: user) }
  let(:other_user) { create(:user) }

  context "when not logged in" do
    it "redirects patch" do
      patch :update, params: { id: card.id, card: { original_text: card.original_text } }
      expect(response). to redirect_to(login_url)
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
end
