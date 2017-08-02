FactoryGirl.define do
  factory :card do
    original_text   "Hello"
    translated_text "Привет"
    review_date     Date.current
    deck

    factory :card_in_deck do
      sequence(:original_text)   { |n| "Original #{n}" }
      sequence(:translated_text) { |n| "Translated #{n}" }
    end
  end
end
