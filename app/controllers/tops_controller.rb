class TopsController < ApplicationController
  # ログイン不要
  skip_before_action :require_login
  def index; end
end
