class OauthsController < ApplicationController
  # gem googleauthのg_csrf_tokenの検証ライブラリの読み込み
  require 'googleauth/id_tokens/verifier'

  # callbackアクションでのCSRF保護を無効化。これがないと外部からのリクエストのため弾かれる
  protect_from_forgery except: :callback

  # ログイン不要
  skip_before_action :require_login

  before_action :verify_g_csrf_token

  def oauth
    #指定されたプロバイダの認証ページにユーザーをリダイレクトさせる
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    # 既存のユーザーをプロバイダ情報を元に検索し、存在すればログイン
    if (@user = login_from(provider))
      redirect_to root_path, notice:"#{provider.titleize}アカウントでログインしました"
    else
      begin
        # ユーザーが存在しない場合はプロバイダ情報を元に新規ユーザーを作成し、ログイン
        signup_and_login(provider)
        redirect_to root_path, notice:"#{provider.titleize}アカウントでログインしました"
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

  # クッキーに保存されたg_csrf_tokenとリクエストパラメータ内のg_csrf_tokenが一致するかを検証
  def verify_g_csrf_token
    if cookies["g_csrf_token"].blank? || params[:g_csrf_token].blank? || cookies["g_csrf_token"] != params[:g_csrf_token]
      redirect_to root_path, notice: '不正なアクセスです'
    end
  end
end
