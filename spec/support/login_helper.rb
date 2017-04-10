def login(email, password)
  visit home_index_path
  click_link "Войти"
  fill_in "Email",  with: email
  fill_in "Пароль", with: password
  click_button "Войти"
end
