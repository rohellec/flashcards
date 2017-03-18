class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy, :review]
  before_action :set_review_text, only: :review

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
    if @card.valid?(:card_review)
      if @card.right_translation?
        flash[:success] = "Правильно"
        @card.update_review_date(3.days.from_now)
      else
        flash[:danger] = "Не правильно"
      end
      redirect_to home_index_url
    else
      render 'home/index'
    end
  end

  private

    def set_card
      @card = Card.find(params[:id])
    end

    def set_review_text
      @card.review_text = params[:card][:review_text]
    end

    def card_params
      params.require(:card).permit(:original_text, :translated_text, :review_date, :review_text)
    end
end
