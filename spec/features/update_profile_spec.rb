require 'rails_helper'

feature "Updating Profile" do
  given(:user) { create(:user, email: "foo@bar.com", password: "foobar") }
  given!(:email) { "john@doe.com" }

  background { login(user.email, "foobar") }

  context "unsuccessfully" do
    background do
      visit edit_user_path(user)
      fill_in "Email",  with: email
      fill_in "Пароль", with: "foobar"
      fill_in "Подтвердите пароль", with: "foobaz"
      click_button "Обновить"
    end

    scenario "doesn't update user fields" do
      user.reload
      expect(user.email).not_to eq email
    end

    scenario "renders user edit page" do
      expect(page).to have_selector("h1", text: "Обновить профиль")
    end

    scenario "renders the error messages" do
      expect(page).to have_css(".has-error")
    end
  end

  context "successfully" do
    background do
      visit edit_user_path(user)
      fill_in "Email",  with: email
      fill_in "Пароль", with: "foobaz"
      fill_in "Подтвердите пароль", with: "foobaz"
      click_button "Обновить"
    end

    scenario "updates user fields" do
      user.reload
      expect(user.email).to eq email
      expect(user.valid_password?("foobaz")).to be_truthy
    end

    scenario "generates success message" do
      expect(page).to have_css(".alert-success", text: "успешно обновлён")
    end
  end

  context "when logged in as wrong user" do
    given(:other_user) { create(:user) }
    background { visit edit_user_path(other_user) }

    scenario "renders edit page for current user" do
      expect(page).to have_selector("input[type=email][value='#{user.email}']")
    end
  end
end
