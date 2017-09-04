FactoryGirl.define do
  factory :card do
    original_text   "Hello"
    translated_text "Привет"
    deck

    factory :card_in_a_row do
      sequence(:original_text)   { |n| "Original #{n}" }
      sequence(:translated_text) { |n| "Translated #{n}" }

      factory :nonpending_card do
        after(:create) do |card, _evaluator|
          card.review_date = Date.tomorrow
          card.save
        end
      end
    end
  end
end
