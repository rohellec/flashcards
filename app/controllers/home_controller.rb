class HomeController < ApplicationController
  include DecksHelper
  helper_method :current_cards

  before_action :store_card_back_location

  def index
    return unless logged_in?
    @card = cards_for_review.order("random()").take if cards_for_review.any?
  end
end
