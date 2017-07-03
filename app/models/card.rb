class Card < ApplicationRecord
  attr_reader :picture_remote_url
  belongs_to :user
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

  def picture_remote_url=(url_value)
    return if url_value.blank?
    self.picture = URI.parse(url_value) unless picture.file?
    @picture_remote_url = url_value
  end

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
