require 'rails_helper'

describe UsersController do
  include Sorcery::TestHelpers::Rails::Controller

  let(:user) { create(:user, email: "foo@bar.com", password: "foobar") }
  let(:other_user) { create(:user) }

  it "redirects edit when not logged in" do
    get :edit, params: { id: user.id }
    expect(response).to redirect_to(login_url)
  end

  it "redirects patch when not logged in" do
    patch :update, params: { id: user.id, user: { email: "foo@baz.com" } }
    expect(response).to redirect_to(login_url)
  end
end
