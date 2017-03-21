class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy, :review]

  def index
    @cards = Card.all
  end

  def show
  end

  def new
    @card = Card.new
  end

  def edit
  end

  def create
    @card = Card.new(card_params)

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
    redirect_to cards_path
  end

  def review
    if params[:card][:original_text].blank?
      @card.errors.add(:original_text, :blank)
      render "home/index"
    else
      if @card.right_translation?(params[:card][:original_text])
        flash[:success] = "Правильно"
        @card.update_review_date(3.days.from_now)
      else
        flash[:danger] = "Не правильно"
      end
      redirect_to home_index_url
    end
  end

  private

    def set_card
      @card = Card.find(params[:id])
    end

    def card_params
      params.require(:card).permit(:original_text, :translated_text, :review_date, :review_text)
    end
end
