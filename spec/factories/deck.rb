FactoryGirl.define do
  factory :deck do
    name "Foo"
    user

    factory :deck_with_cards do
      transient do
        cards_count 10
      end

      after(:create) do |deck, evaluator|
        create_list(:card_in_deck, evaluator.cards_count, deck: deck)
      end
    end
  end
end
