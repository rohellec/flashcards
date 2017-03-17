class HomeController < ApplicationController

  def index
    if Card.for_review.any?
      min, max = Card.for_review.pluck('MIN(id), MAX(id)')[0]
      @card = Card.for_review.where("id >= ?", rand(min..max)).take
    end
  end
end
