module SimpleMode
  class QuizzesController < ApplicationController

    # QuizUtilsモジュール（calculate_distanceメソッド、generate_choicesメソッド）
    include QuizUtils

    # ログインしている場合にのみユーザーをセットする
    before_action :set_user_if_logged_in


    # def new ;end #Quiz_Utilsにnewメソッドのモジュール


    def show
      # 各sessionの値を取得し、インスタンス変数に代入する
      @locations = Location.find(session[:locations])
      @correct_answer = session[:correct_answer].to_i
      @selected_choice = params[:selected_choice].to_i

      # JavaScriptに渡せるように設定
      ## 地点1
      gon.latitude1 = @locations[0].latitude
      gon.longitude1 = @locations[0].longitude
      ## 地点2
      gon.latitude2 = @locations[1].latitude
      gon.longitude2 = @locations[1].longitude

      # ユーザーが選んだ回答が正解か判断し、その結果をインスタンス変数に代入する
      @result = if @selected_choice == @correct_answer
                  t('quizzes.show.correct')
                else
                  t('quizzes.show.incorrect')
                end

      # ログインしている場合にのみ回答履歴を保存
      if @current_user
        QuizHistory.create!(
          user_id: @current_user.id,
          location1_id: @locations[0].id,
          location2_id: @locations[1].id,
          user_answer: @selected_choice.to_i,
          correct_answer: @correct_answer.to_i,
          is_correct: @selected_choice == @correct_answer,
          mode: 'simple'
        )
      end
    end


    # private
    # Quiz_Utilsにcalculate_distanceメソッドのモジュール
    # Quiz_Utilsにgenerate_choicesメソッドのモジュール

  end
end
