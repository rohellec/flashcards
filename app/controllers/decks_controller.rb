class DecksController < ApplicationController
  before_action :require_login
  before_action :set_deck, only: [:show, :edit, :update, :destroy, :switch]
  before_action :store_card_back_location, only: [:index, :show]

  def index
    @decks = current_user.decks
  end

  def show
    @cards = @deck.cards
  end

  def new
    @deck = Deck.new
  end

  def edit
  end

  def create
    @deck = current_user.decks.build(deck_params)
    if @deck.save
      redirect_to @deck
    else
      render 'new'
    end
  end

  def update
    if @deck.update(deck_params)
      redirect_to @deck
    else
      render 'edit'
    end
  end

  def destroy
    @deck.destroy
    redirect_to decks_path
  end

  def switch
    current_user.switch_deck(@deck)
    redirect_to decks_path
  end

  private

  def set_deck
    @deck = current_user.decks.find(params[:id])
  end

  def deck_params
    params.require(:deck).permit(:name)
  end
end
