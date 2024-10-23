class MypagesController < ApplicationController
  # ログイン中のユーサー情報をセット
  before_action :set_user

  def show
    @quiz_histories = current_user.quiz_histories.includes(:location1, :location2)
                                  .order(created_at: :desc)
                                  .page(params[:page])
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t('mypages.edit.success', item: User.model_name.human)
      redirect_to mypage_path
    else
      flash.now[:error] = t('mypages.edit.failure', item: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def map_view
    # 受け取った履歴IDを取得
    @history = current_user.quiz_histories.find(params[:id])

    # 履歴詳細から地点情報を取得
    location1 = @history.location1
    location2 = @history.location2

    # 地点情報の緯度・経度をgon変数にセット
    set_gon_locations(location1, location2)
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email, :name)
  end

  def set_gon_locations(location1, location2)
    gon.latitude1 = location1.latitude
    gon.longitude1 = location1.longitude
    gon.latitude2 = location2.latitude
    gon.longitude2 = location2.longitude
  end

end