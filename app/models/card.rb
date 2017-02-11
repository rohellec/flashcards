class Card < ApplicationRecord
  def review_date_formatted
    review_date.strftime('%d/%m/%Y')
  end
end
