class MypagesController < ApplicationController

  before_action :set_user, only: %i[edit update]

  def show; end
  def edit; end

  # 更新
  def update
    if @user.update(user_params)
      flash[:success] = t('mypages.edit.success', item: User.model_name.human)
      redirect_to mypage_path
    else
      flash.now[:error] = t('mypages.edit.failure', item: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end


  private

  # ログイン中のユーザーのidを取得し、@userに代入
  def set_user
    @user = User.find(current_user.id)
  end

  # userから各データを受け取ったパラメータ
  def user_params
    params.require(:user).permit(:email, :name)
  end
end
