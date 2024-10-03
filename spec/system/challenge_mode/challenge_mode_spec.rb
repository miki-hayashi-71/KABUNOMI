require 'rails_helper'

RSpec.describe 'チャレンジモードクイズ', type: :system do
  let!(:location1) { FactoryBot.create(:location, :tokyo) }
  let!(:location2) { FactoryBot.create(:location, :osaka) }
  let!(:user) { FactoryBot.create(:user) }

  before do
    # モック: 距離計算と選択肢生成
    allow_any_instance_of(QuizUtils).to receive(:calculate_distance).and_return(500)
    allow_any_instance_of(QuizUtils).to receive(:generate_choices).and_return([500, 600, 400])
    allow(Location).to receive_message_chain(:order, :limit).and_return([location1, location2])
  end

  context '画面の遷移と表示確認' do
    before do
      login_as(user)
    end

    it 'トップページからクイズ開始画面に遷移できること' do
      visit root_path
      click_on 'チャレンジモードに挑戦！', id: 'challenge_mode-link'
      expect(page).to have_current_path(start_challenge_mode_quizzes_path)
    end

    it 'クイズ開始画面からクイズ出題画面に遷移できること' do
      visit start_challenge_mode_quizzes_path
      click_on 'クイズを開始する', id: 'new_quiz-link'
      expect(page).to have_current_path(new_challenge_mode_quiz_path)
    end

    it '解答の選択後、次の問題に進むこと' do
      visit new_challenge_mode_quiz_path
      find('button', text: '約500km', wait: 5).click
      expect(page).to have_current_path(new_challenge_mode_quiz_path)
    end

    it '全10問の回答後に結果ページに遷移できること' do
      visit new_challenge_mode_quiz_path
      10.times do
        sleep 1
        find('button', text: '約500km').click
        sleep 1
      end
      expect(page).to have_current_path(result_challenge_mode_quizzes_path, ignore_query: true)
    end
  end

  context 'クイズの履歴保存' do
    before do
      login_as(user)
      visit new_challenge_mode_quiz_path
    end

    it '正解した場合、履歴が保存されること' do
      click_on '約500km'
      sleep 1
      expect(QuizHistory.count).to eq(1)
      expect(QuizHistory.last.is_correct).to be true
    end

    it '不正解の場合、履歴が保存されること' do
      click_on '約400km'
      sleep 1
      expect(QuizHistory.count).to eq(1)
      expect(QuizHistory.last.is_correct).to be false
    end
  end

  context '結果とランキングの表示' do
    before do
      login_as(user)
      visit new_challenge_mode_quiz_path
    end

    it '結果発表の画面が正しく表示されること' do
      10.times do
        sleep 1
        find('button', text: '約500km').click
        sleep 1
      end
      expect(page).to have_current_path(result_challenge_mode_quizzes_path, ignore_query: true)
    end

    it '20位以内にランクインした場合、特別なメッセージが表示されること' do
      10.times do
        find('button', text: '約500km').click
      end
      expect(page).to have_current_path(result_challenge_mode_quizzes_path, ignore_query: true)
      expect(page).to have_content('20位以内にランクインしました🎉')
    end
  end

  context 'ユーザー権限に基づく表示' do
    it 'ログインしていないユーザーがチャレンジモードにアクセスできないこと' do
      visit logout_path
      visit start_challenge_mode_quizzes_path
      expect(page).to have_current_path(login_path)
      expect(page).to have_content('ログインが必要です')
    end

    it 'ログイン済みユーザーはチャレンジモードにアクセスできること' do
      login_as(user)
      visit start_challenge_mode_quizzes_path
      expect(page).to have_current_path(start_challenge_mode_quizzes_path)
    end
  end
end
