class CardsController < ApplicationController
  include DecksHelper

  before_action :require_login
  before_action :set_deck, only: [:new, :create]
  before_action :set_card, only: [:show, :edit, :update, :destroy, :review]
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
    if params[:card][:original_text].present?
      if @card.right_translation?(params[:card][:original_text])
        flash[:success] = "Правильно"
        @card.update_next_review_date
      else
        flash[:danger] = "Не правильно"
      end
      redirect_to home_index_url
    else
      @card.errors.add(:original_text, :blank)
      render "home/index"
    end
  end

  private

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
