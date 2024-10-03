class ApplicationController < ActionController::Base
  add_flash_types :success, :danger, :alert

  private

  def not_authenticated
    redirect_to login_path, alert: t('alerts.require_login')
  end

end