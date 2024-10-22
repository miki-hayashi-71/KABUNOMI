class ApplicationController < ActionController::Base
  # 各ページのログイン要否の設定に必要
  before_action :require_login
  add_flash_types :success, :danger, :alert

  private

  def not_authenticated
    redirect_to login_path, alert: t('alerts.require_login')
  end

end