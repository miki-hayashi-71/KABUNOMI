class UserSessionsController < ApplicationController
  # ユーザーがログインしていなくてもログインページにアクセスできるように設定
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      flash[:success] = t('user_sessions.new.success')
      redirect_to root_path
    else
      flash.now[:error] = t('user_sessions.new.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:success] = t('.success')
    redirect_to root_path, status: :see_other
  end
end
