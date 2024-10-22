module ChallengeMode
  class QuizzesController < ApplicationController

    # QuizUtilsモジュール（calculate_distanceメソッド、generate_choicesメソッド）
    include QuizUtils

    # ログイン不要（rankingのみ）
    skip_before_action :require_login, only: %i[ranking]

    def start;end

    def new
      # チャレンジモードのセッションを初期化（セッションが存在しなければ実行）
      session[:challenge_mode] ||= {
        question_count: 10,  # 出題数
        current_question: 0,  # 現在の問題数
        correct_answers: 0  # 正解数
      }

      # challenge_modeハッシュをchallenge変数に代入し、キーをシンボルに変換。変換しとかないと動かなかった
      challenge = session[:challenge_mode].deep_symbolize_keys

      # 全ての問題に解答済みの場合、結果画面にリダイレクト
      if challenge[:current_question] >= challenge[:question_count]
        redirect_to result_challenge_mode_quizzes_path
        return
      end

      # ランダムに並び替え、そのうち2件を取得する
      @locations = Location.order('RANDOM()').limit(2)

      # calculate_distanceのメソッドに対して上記で取得した2地点を引数として渡す
      @distance = calculate_distance(@locations[0], @locations[1])

      # generate_choicesメソッドにAPIで計算した正答な距離を引数として@choicesに代入
      @choices = generate_choices(@distance)

      # 地図表示のためにgonへ変換（quiz_utils参照）
      set_gon_locations(@locations)

      # セッションに保存（quiz_utils参照）
      set_session_data(@locations, @distance, @choices)

      # 出題カウントを増やす
      challenge[:current_question] += 1
      session[:challenge_mode] = challenge
    end

    def show
      # newで作成されたセッションの情報を読み込み、キーをシンボルに変換
      challenge = session[:challenge_mode].deep_symbolize_keys

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

      # 正解の場合、正解数をカウントアップ
      challenge[:correct_answers] += 1 if @is_correct

      # ログインしている場合にのみ回答履歴を保存
      save_quiz_history('challenge_10') if @current_user

      # セッションの更新
      session[:challenge_mode] = challenge

      # 次のクイズに進むか、結果画面に遷移
      if challenge[:current_question] < challenge[:question_count]
        redirect_to new_challenge_mode_quiz_path
      else
        redirect_to result_challenge_mode_quizzes_path
      end
    end

    def result
      # セッションがない場合はトップページにリダイレクト
      unless session[:challenge_mode]
        redirect_to root_path, alert: t('alerts.session_expired')
        return
      end

      # newで作成されたセッションの情報を読み込み、キーをシンボルに変換
      challenge = session[:challenge_mode].deep_symbolize_keys

      # セッションの情報をインスタンス変数に代入
      @correct_answers = challenge[:correct_answers]
      @question_count = challenge[:question_count]

      # 結果をデータベースに保存
      @current_challenge = ChallengeResult.create!(
        user: current_user,
        total_questions: @question_count,
        correct_answers: @correct_answers
      )

      # 上位20名のランキングを取得
      @rankings = ChallengeResult
                  .includes(:user) # N+1 問題を防ぐため、ユーザー情報を一括取得
                  .order(correct_answers: :desc, created_at: :asc) # 正答数の降順に並べ替え
                  .limit(20) # 上位20名を表示

      # 今回の挑戦が20位以内にランクインしているか確認。trueかfalseを代入
      @rank_in_top_20 = @rankings.any? { |result| result.id == @current_challenge.id }

      # セッションのクリア
      session.delete(:challenge_mode)
    end

    def ranking
      @rankings = ChallengeResult
                  .includes(:user) # N+1 問題を防ぐため、ユーザー情報を一括取得
                  .order(correct_answers: :desc, created_at: :desc) # 正答数の降順に並べ替え
                  .page(params[:page])
    end


  end
end
