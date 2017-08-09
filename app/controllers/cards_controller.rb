class CardsController < ApplicationController
  include DecksHelper

  before_action :require_login
  before_action :set_deck, only: [:new, :create]
  before_action :set_card, only: [:show, :edit, :update, :destroy, :review]
  before_action :require_original_text, only: [:review]
  before_action :store_card_back_location, only: [:index]

  def index
    @cards = current_user.cards
  end

  def show
  end

  def new
    @card = Card.new
  end

  def edit
  end

  def back
    if session[:card_back_url]
      redirect_to session[:card_back_url]
    elsif current_deck
      redirect_to deck_url(current_deck)
    else
      redirect_to cards_url
    end
  end

  def create
    @card = @deck.cards.build(card_params)
    if @card.save
      redirect_to @card
    else
      render 'new'
    end
  end

  def update
    if @card.update(card_params)
      redirect_to @card
    else
      render 'edit'
    end
  end

  def destroy
    @card.destroy
    redirect_to card_back_url
  end

  def review
    translation = params[:card][:original_text]
    if @card.review(translation)
      message = "Верно, правильное значение - #{@card.original_text}"
      typos_count = @card.distance_to(translation)
      message += ", у Вас опечатка - #{translation}" unless typos_count.zero?
      flash[:success] = message
    else
      flash[:danger] = "Не верно, правильное значение - #{@card.original_text}"
    end
    redirect_to home_index_url
  end

  private

    def require_original_text
      return if params[:card][:original_text].present?
      @card.errors.add(:original_text, :blank)
      render "home/index"
    end

    def set_deck
      @deck = current_user.decks.find_by(id: params[:deck_id])
    end

    def set_card
      @card = current_user.cards.find(params[:id])
    end

    def card_params
      params.require(:card).permit(:original_text, :translated_text, :review_date, :review_text,
                                   :picture, :picture_remote_url)
    end
end
