class SessionsController < ApplicationController

  def new
  end

  def create
    if @user = login(params[:session][:email], params[:session][:password], params[:session][:remember])
      redirect_back_or_to(:home_index, info: "Вы успешно вошли")
    else
      flash.now[:danger] = "Неправильный email или пароль"
      render "new"
    end
  end

  def destroy
    logout
    redirect_to(:home_index)
  end

  private

    def session_params
      params.require(:session).permit(:email, :password)
    end
end
