class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update]
  before_action :set_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      flash[:success] = "Добро пожаловать во Флэшкарточкер! \
        Добавьте несколько карточек для начала работы"
      redirect_to home_index_url
    else
      render "new"
    end
  end

  def update
    if current_user.update(user_params)
      flash[:success] = "Ваш профиль успешно обновлён"
      redirect_to home_index_url
    else
      render "edit"
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
