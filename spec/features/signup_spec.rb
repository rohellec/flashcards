require 'rails_helper'

feature "User Sign up" do
  context "Unsuccessfull" do
    background do
      visit signup_url
      fill_in "Email",  with: "john@doe"
      fill_in "Пароль", with: "foobar"
      fill_in "Подтвердите пароль", with: "foobaz"
    end

    scenario "doesn't create new user" do
      expect { click_on "Зарегистрироваться" }.not_to change { User.count }
    end

    scenario "renders the sign up page" do
      click_on "Зарегистрироваться"
      expect(page).to have_selector("h1", text: "Регистрация")
    end

    scenario "renders the error messages" do
      click_on "Зарегистрироваться"
      expect(page).to have_css(".has-error", count: 2)
    end
  end

  context "Successfull" do
    background do
      visit signup_url
      fill_in "Email",  with: "john.doe@example.com"
      fill_in "Пароль", with: "foobar"
      fill_in "Подтвердите пароль", with: "foobar"
    end

    scenario "creates new user" do
      expect { click_on "Зарегистрироваться" }.to change { User.count }.by 1
    end

    scenario "logs the user in" do
      click_on "Зарегистрироваться"
      expect(page).not_to have_link("Войти", href: login_path)
      expect(page).to have_link("Колоды", href: decks_path)
    end

    scenario "generates success message" do
      click_on "Зарегистрироваться"
      expect(page).to have_css(".alert-success", text: "Добро пожаловать")
    end
  end
end
