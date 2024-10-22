module SimpleMode
  class QuizzesController < ApplicationController

    # QuizUtilsモジュール（calculate_distanceメソッド、generate_choicesメソッド）
    include QuizUtils

    # ログイン不要
    skip_before_action :require_login

    # ログインしている場合にのみユーザーをセットする
    before_action :set_user_if_logged_in

    def new
      # ランダムに並び替え、そのうち2件を取得する
      @locations = Location.order('RANDOM()').limit(2)

      # calculate_distanceのメソッド（quiz_utils参照）に対して上記で取得した2地点を引数として渡す
      @distance = calculate_distance(@locations[0], @locations[1])

      # generate_choicesメソッド（quiz_utils参照）にAPIで計算した正答な距離を引数として@choicesに代入
      @choices = generate_choices(@distance)

      # 地図表示のためにgonへ変換（quiz_utils参照）
      set_gon_locations(@locations)

      # セッションに保存（quiz_utils参照）
      set_session_data(@locations, @distance, @choices)
    end


    def show
      # 各sessionの値を取得し、インスタンス変数に代入する
      @locations = Location.find(session[:locations])
      @correct_answer = session[:correct_answer].to_i
      @selected_choice = params[:selected_choice].to_i

      # 正誤判定
      @is_correct = @selected_choice == @correct_answer

      # ユーザーが選んだ回答が正解か判断し、その結果をインスタンス変数に代入する
      @result = if @is_correct
                  t('quizzes.show.correct')
                else
                  t('quizzes.show.incorrect')
                end

      # 地図表示のためにgonへ変換（quiz_utils参照）
      set_gon_locations(@locations)

      # ログインしている場合にのみ回答履歴を保存
      save_quiz_history('simple') if @current_user
    end


  end
end
