class User < ApplicationRecord
  authenticates_with_sorcery!
  before_save { email.downcase! }
  has_many :cards, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d]+(\.[a-z\d]+)?\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 },
                       confirmation: true, if: -> { new_record? || changes[:crypted_password] }
end
