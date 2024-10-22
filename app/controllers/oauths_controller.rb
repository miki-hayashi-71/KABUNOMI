class OauthsController < ApplicationController
  # gem googleauthのg_csrf_tokenの検証ライブラリの読み込み
  require 'googleauth/id_tokens/verifier'

  # callbackアクションでのCSRF保護を無効化。これがないと外部からのリクエストのため弾かれる
  protect_from_forgery except: :callback

  # ログイン不要
  skip_before_action :require_login

  before_action :verify_g_csrf_token

  def oauth
    # 指定されたプロバイダの認証ページにユーザーをリダイレクトさせる
    login_at(auth_params[:provider])
  end

  # googleauthライブラリのメソッドを使って、戻ってきたcredentialsをデコード
  def callback
    # 戻ってきたcredentialsのトークンをデコードし、ペイロード(ユーザー情報など)を取得
    payload = Google::Auth::IDTokens.verify_oidc(params[:credential], aud: Rails.application.credentials.dig(:google, :google_client_id) )
    # デコードしたトークンから取得したユーザーのメールアドレスで、ユーザーを検索または新規作成
    user = User.find_or_create_by(email: payload['email'])
    session[:user_id] = user.id
    redirect_to root_path, success: 'ログインしました'
  end

  private

  # クッキーに保存されたg_csrf_tokenとリクエストパラメータ内のg_csrf_tokenが一致するかを検証
  def verify_g_csrf_token
    if cookies["g_csrf_token"].blank? || params[:g_csrf_token].blank? || cookies["g_csrf_token"] != params[:g_csrf_token]
      redirect_to root_path, notice: '不正なアクセスです'
    end
  end
end
