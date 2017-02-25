class Card < ApplicationRecord
  validates :original_text, :translated_text, :review_date, presence: true
  validate  :can_not_be_equal

  before_validation :set_original_review_date, on: :create

  private

    def can_not_be_equal
      if !(original_text.blank? || translated_text.blank?) &&
           translated_text.strip.casecmp?(original_text.strip)
        errors.add(:translated_text, "can't be equal to original text")
      end
    end

    def set_original_review_date
      self.review_date = Date.today.advance(days: 3)
    end
end
