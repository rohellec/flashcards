class Card < ApplicationRecord
  scope :for_review, -> { where "? >= review_date", Date.current }

  validates :original_text, :translated_text, :review_date, presence: true
  validates :review_text, presence: true, on: :card_review
  validate  :can_not_be_equal

  before_validation :set_original_review_date, on: :create

  attr_accessor :review_text

  def right_translation?
    review_text.strip.casecmp?(original_text)
  end

  def update_review_date(param)
    update(review_date: param)
  end

  private

    def can_not_be_equal
      if !(original_text.blank? || translated_text.blank?) &&
           translated_text.strip.casecmp?(original_text.strip)
        errors.add(:translated_text, "can't be equal to original text")
      end
    end

    def set_original_review_date
      self.review_date = 3.days.from_now
    end
end
