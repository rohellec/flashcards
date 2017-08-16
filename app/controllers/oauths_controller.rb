class OauthsController < ApplicationController
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if (@user = login_from(provider))
      flash[:info] = "Вы успешно авторизовались с помощью #{provider.titleize}!"
      redirect_to home_index_path
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        flash[:info] = "Вы успешно авторизовались с помощью #{provider.titleize}!"
        redirect_to home_index_path
      rescue
        flash[:danger] = "Не удалось авторизоваться с помощью #{provider.titleize}."
        redirect_to home_index_path
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end
