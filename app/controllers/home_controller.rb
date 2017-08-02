class HomeController < ApplicationController
  include DecksHelper

  before_action :store_card_back_location

  def index
    return unless logged_in?
    @cards = current_deck ? current_deck.cards : current_user.cards
    @review_cards = @cards.for_review
    @card = @review_cards.order("random()").take if @review_cards.any?
  end
end
