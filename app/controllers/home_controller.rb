class HomeController < ApplicationController
  def index
    if logged_in?
      review_cards = current_user.cards.for_review
      @card = review_cards.order("random()").take if review_cards.any?
    end
  end
end
