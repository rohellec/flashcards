class Card < ApplicationRecord
  belongs_to :user
  scope :for_review, -> { where "? >= review_date", Date.current }

  validates :original_text, :translated_text, :review_date, presence: true
  validate  :can_not_be_equal

  before_validation :set_next_review_date, on: :create

  def right_translation?(param)
    param.strip.casecmp?(original_text)
  end

  def update_next_review_date
    set_next_review_date
    save
  end

  private

    def can_not_be_equal
      if !(original_text.blank? || translated_text.blank?) &&
           translated_text.strip.casecmp?(original_text.strip)
        errors.add(:translated_text, "can't be equal to original text")
      end
    end

    def set_next_review_date
      self.review_date = 3.days.from_now
    end
end
