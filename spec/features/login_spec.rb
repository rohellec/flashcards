require 'rails_helper'

feature "Logging in" do
  given(:user) { create(:user, email: "foo@bar.com", password: "foobar") }

  background { visit home_index_path }

  context "initially" do
    scenario "there is a link for login" do
      expect(page).to have_link("Войти", href: login_path)
    end

    scenario "there is a link for signup" do
      expect(page).to have_link("Регистрация", href: signup_path)
    end

    scenario "there is no link for adding card" do
      expect(page).not_to have_link("Добавить карточку", href: new_card_path)
    end
  end

  context "unsuccessfully" do
    background do
      click_link "Войти"
      click_button "Войти"
    end

    scenario "shows login page" do
      expect(page).to have_selector("input[type=submit][value=Войти]")
    end

    scenario "generates error" do
      expect(page).to have_css(".alert-danger")
    end

    scenario "doesn't show link for adding card" do
      expect(page).not_to have_link("Добавить карточку", href: new_card_path)
    end
  end

  context "successfully" do
    background do
      click_link "Войти"
      fill_in "Email",  with: user.email
      fill_in "Пароль", with: "foobar"
      click_button "Войти"
    end

    scenario "redirects to home page" do
      expect(page).to have_current_path(home_index_path)
    end

    scenario "generates info message" do
      expect(page).to have_css(".alert-info")
    end

    scenario "logs the user in" do
      expect(page).not_to have_link("Войти", href: login_path)
      expect(page).to have_link("Добавить карточку", href: new_card_path)
    end

    context "then logging out" do
      background { click_link "Выйти" }

      scenario "there is a link for login" do
        expect(page).to have_link("Войти", href: login_path)
      end

      scenario "there is no link for adding card" do
        expect(page).not_to have_link("Добавить карточку", href: new_card_path)
      end
    end
  end
end
