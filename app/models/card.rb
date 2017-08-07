class Card < ApplicationRecord
  attr_reader :picture_remote_url
  belongs_to :deck
  has_attached_file :picture, styles: { normal: "360x360#" },
                              default_style: :normal,
                              default_url: "/images/:class/:attachment/:style/missing.png"

  scope :for_review, -> { where "? >= review_date", Date.current }

  validates :original_text, :translated_text, :review_date, presence: true
  validates_attachment :picture, content_type: { content_type: /\Aimage/ },
                                 file_name: { matches: [/png\z/, /jpe?g\z/, /gif\z/] },
                                 size: { less_than: 5.megabytes }
  validate :can_not_be_equal

  before_validation :set_next_review_date, on: :create

  REVIEW_DATES = {
    0 => Time.current,
    1 => 12.hours.from_now,
    2 => 3.days.from_now,
    3 => 1.week.from_now,
    4 => 2.weeks.from_now,
    5 => 1.month.from_now
  }.freeze

  def picture_remote_url=(url_value)
    return if url_value.blank?
    self.picture = URI.parse(url_value) unless picture.file?
    @picture_remote_url = url_value
  end

  def review(param)
    result = param.strip.casecmp?(original_text)
    if result
      self.fail_reviews = 0
      increase_success_reviews
    else
      self.fail_reviews += 1
      decrease_success_reviews
    end
    set_next_review_date
    save
    result
  end

  private

  def can_not_be_equal
    if !(original_text.blank? || translated_text.blank?) &&
         translated_text.strip.casecmp?(original_text.strip)
      errors.add(:translated_text, "can't be equal to original text")
    end
  end

  def decrease_success_reviews
    return if success_reviews.zero? || !(fail_reviews % 3).zero?
    self.success_reviews -= 1
  end

  def increase_success_reviews
    return if success_reviews >= REVIEW_DATES.keys.max
    self.success_reviews += 1
  end

  def set_next_review_date
    self.review_date = REVIEW_DATES[success_reviews]
  end
end
