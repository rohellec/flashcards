FactoryGirl.define do
  factory :user do
    email    "john.doe@example.com"
    password "foobar"
    password_confirmation "foobar"

    factory :user_with_cards do
      after(:create) do |user, _evaluator|
        create(:deck_with_cards, user: user)
      end
    end

    factory :user_without_pending_cards do
      after(:create) do |user, _evaluator|
        create(:deck_without_pending_cards, user: user)
      end
    end
  end
end
