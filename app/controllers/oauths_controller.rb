class OauthsController < ApplicationController

  # ログイン不要
  skip_before_action :require_login

  def oauth
    #指定されたプロバイダの認証ページにユーザーをリダイレクトさせる
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    @user = login_from(provider)
    if (@user)
      redirect_to root_path, success:"#{provider.titleize}アカウントでログインしました"
    else
      begin
        # ユーザーが存在しない場合はプロバイダ情報を元に新規ユーザーを作成し、ログイン
        signup_and_login(provider)
        redirect_to root_path, success:"#{provider.titleize}アカウントでログインしました"
      rescue
        redirect_to root_path, alert:"#{provider.titleize}アカウントでのログインに失敗しました"
      end
    end
  end

  private

    def auth_params
    params.permit(:code, :provider)
  end

  def signup_and_login(provider)
    @user = create_from(provider)
    reset_session
    auto_login(@user)
  end

end
