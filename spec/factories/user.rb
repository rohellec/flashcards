FactoryGirl.define do
  factory :user do
    email    "john.doe@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
