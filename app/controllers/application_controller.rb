class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def not_authenticated
    flash[:danger] = "Пожалуйста, для начала войдите"
    redirect_to login_url
  end

  def store_card_back_location
    session[:card_back_url] = request.original_url if request.get?
  end
end
