require 'rails_helper'

RSpec.describe 'チャレンジモードクイズ', type: :system do
  let!(:location1) { FactoryBot.create(:location, :tokyo) }
  let!(:location2) { FactoryBot.create(:location, :osaka) }
  let!(:user) { FactoryBot.create(:user) }

  before do
    # モック: 距離計算と選択肢生成
    allow_any_instance_of(QuizUtils).to receive(:calculate_distance).and_return(500)
    allow_any_instance_of(QuizUtils).to receive(:generate_choices).and_return([500, 600, 400])
    # モック: ランダムで2地点を取得する部分
    allow(Location).to receive_message_chain(:order, :limit).and_return([location1, location2])
  end

  context '画面の遷移と表示確認', js: true do
    before do
      Capybara.reset_sessions!
      login_as(user)
    end

    it 'トップページからクイズ開始画面に遷移できること' do
      handle_unexpected_alert do
        visit root_path
        click_on 'チャレンジモードに挑戦！', id: 'challenge_mode-link'
        expect(page).to have_current_path(start_challenge_mode_quizzes_path)
      end
    end

    it 'クイズ開始画面からクイズ出題画面に遷移できること' do
      handle_unexpected_alert do
        visit start_challenge_mode_quizzes_path
        click_on 'クイズを開始する', id: 'new_quiz-link'
        expect(page).to have_current_path(new_challenge_mode_quiz_path)
      end
    end

    it '解答の選択後、次の問題に進むこと' do
      visit start_challenge_mode_quizzes_path
      click_on 'クイズを開始する', id: 'new_quiz-link'
      handle_unexpected_alert do
        expect(page).to have_current_path(new_challenge_mode_quiz_path)
        find('button', text: '約500km', wait: 5).click
        expect(page).to have_current_path(new_challenge_mode_quiz_path)
      end
    end

    it '全10問の回答後に結果ページに遷移できること' do
      visit start_challenge_mode_quizzes_path
      click_on 'クイズを開始する', id: 'new_quiz-link'
      handle_unexpected_alert do
        10.times do
          expect(page).to have_current_path(new_challenge_mode_quiz_path)
          sleep 2
          expect(page).to have_button('約500km')
          find('button', text: '約500km').click
        end
        expect(page).to have_current_path(result_challenge_mode_quizzes_path, ignore_query: true)
      end
    end
  end

  context 'クイズの履歴保存', js: true do
    before do
      login_as(user)
      visit new_challenge_mode_quiz_path
    end

    it '正解した場合、履歴が保存されること' do
      handle_unexpected_alert do
        click_on '約500km'
        expect(page).to have_current_path(new_challenge_mode_quiz_path)
        expect(QuizHistory.count).to eq(1)
        expect(QuizHistory.last.is_correct).to be true
      end
    end

    it '不正解の場合、履歴が保存されること' do
      handle_unexpected_alert do
        click_on '約400km'
        expect(page).to have_current_path(new_challenge_mode_quiz_path)
        expect(QuizHistory.count).to eq(1)
        expect(QuizHistory.last.is_correct).to be false
      end
    end
  end

  context '結果とランキングの表示', js: true do
    before do
      Capybara.reset_sessions!
      login_as(user)
      visit start_challenge_mode_quizzes_path
      click_on 'クイズを開始する', id: 'new_quiz-link'
    end

    it '結果発表の画面が正しく表示されること' do
      handle_unexpected_alert do
        10.times do
          expect(page).to have_current_path(new_challenge_mode_quiz_path)
          sleep 2
          expect(page).to have_button('約500km')
          find('button', text: '約500km').click
        end
        expect(page).to have_current_path(result_challenge_mode_quizzes_path)
      end
    end

    it '20位以内にランクインした場合、特別なメッセージが表示されること' do
      handle_unexpected_alert do
        10.times do
          expect(page).to have_current_path(new_challenge_mode_quiz_path)
          sleep 2
          expect(page).to have_button('約500km')
          find('button', text: '約500km').click
        end
        expect(page).to have_current_path(result_challenge_mode_quizzes_path)
        sleep 2
        expect(page).to have_content('20位以内にランクインしました🎉')
      end
    end
  end

  context 'ユーザー権限に基づく表示' do
    it 'ログインしていないユーザーがチャレンジモードにアクセスできないこと' do
      handle_unexpected_alert do
        visit logout_path
        visit start_challenge_mode_quizzes_path
        expect(page).to have_current_path(login_path)
        expect(page).to have_content('ログインが必要です')
      end
    end

    it 'ログイン済みユーザーはチャレンジモードにアクセスできること' do
      handle_unexpected_alert do
        login_as(user)
        visit start_challenge_mode_quizzes_path
        expect(page).to have_current_path(start_challenge_mode_quizzes_path)
      end
    end
  end

  # アラートを検知して処理するヘルパー
  def handle_unexpected_alert
    yield
  rescue Selenium::WebDriver::Error::UnexpectedAlertOpenError
    # アラートが表示された場合はOKをクリックして閉じる
    begin
      page.driver.browser.switch_to.alert.accept
    rescue Selenium::WebDriver::Error::NoSuchAlertError
      # アラートが存在しない場合は無視
    end
    retry # 処理を再試行
  end
end