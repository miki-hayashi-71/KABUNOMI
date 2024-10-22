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

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email, :name)
  end
end