FactoryGirl.define do
  factory :deck do
    name "Foo"
    user

    transient do
      cards_count 10
    end

    factory :deck_with_cards do
      after(:create) do |deck, evaluator|
        create_list(:card_in_a_row, evaluator.cards_count, deck: deck)
      end
    end

    factory :deck_without_pending_cards do
      after(:create) do |deck, evaluator|
        create_list(:nonpending_card, evaluator.cards_count, deck: deck)
      end
    end
  end
end
