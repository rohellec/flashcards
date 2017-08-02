require 'rails_helper'

describe HomeController do
  include Sorcery::TestHelpers::Rails::Controller

  let(:user) { create(:user) }

  context "before index" do
    before do
      login_user(user)
      get :index
    end

    it "stores request url in a session for cards_back_url" do
      expect(session[:card_back_url]).to eq(home_index_url)
    end
  end
end
