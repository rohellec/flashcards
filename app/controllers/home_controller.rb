class HomeController < ApplicationController
  def index
    if Card.for_review.any?
      @card = Card.for_review.order("random()").take
    end
  end
end
