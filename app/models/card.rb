class Card < ApplicationRecord
  validates :original_text, :translated_text, :review_date, presence: true
  validate  :can_not_be_equal

  private

    def can_not_be_equal
      if !(original_text.blank? || translated_text.blank?) &&
           translated_text.strip.casecmp?(original_text.strip)
        errors.add(:translated_text, "can't be equal to original text")
      end
    end
end
