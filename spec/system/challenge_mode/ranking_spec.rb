require 'rails_helper'

RSpec.describe 'チャレンジモードのランキング', type: :system do
  let!(:top_user) { FactoryBot.create(:user, name: 'ユーザー1') }
  let!(:second_user) { FactoryBot.create(:user, name: 'ユーザー2') }
  let!(:third_user) { FactoryBot.create(:user, name: 'ユーザー3') }

  let!(:top_user_result) { FactoryBot.create(:challenge_result, user: top_user, correct_answers: 9, total_questions: 10) }
  let!(:second_user_result) { FactoryBot.create(:challenge_result, user: second_user, correct_answers: 8, total_questions: 10) }
  let!(:third_user_result) { FactoryBot.create(:challenge_result, user: third_user, correct_answers: 7, total_questions: 10) }

  context '画面の遷移' do
    it 'ランキングページが正しく表示されること' do
      visit root_path
      click_on 'チャレンジモードのランキングを見る', id: 'ranking-link'
      expect(page).to have_current_path(challenge_mode_ranking_path)
    end
  end

  context '画面の表示' do

    before do
      login_as(top_user)
      visit challenge_mode_ranking_path
    end

    it 'ランキングが正しく表示されていること' do
      within 'table' do
        expect(page).to have_content('ユーザー1'), 'ユーザー1がランキングに表示されていません。'
        expect(page).to have_content('9 / 10'), 'ユーザー1の正答数が正しく表示されていません。'

        expect(page).to have_content('ユーザー2'), 'ユーザー2がランキングに表示されていません。'
        expect(page).to have_content('8 / 10'), 'ユーザー2の正答数が正しく表示されていません。'

        expect(page).to have_content('ユーザー3'), 'ユーザー3がランキングに表示されていません。'
        expect(page).to have_content('7 / 10'), 'ユーザー3の正答数が正しく表示されていません。'
      end
    end

    it 'ランキングが正しい順序で表示されていること' do
      rows = all('table tbody tr').map(&:text)

      expect(rows[0]).to include('ユーザー1'), 'ランキングの1位がユーザー1ではありません。'
      expect(rows[1]).to include('ユーザー2'), 'ランキングの2位がユーザー2ではありません。'
      expect(rows[2]).to include('ユーザー3'), 'ランキングの3位がユーザー3ではありません。'
    end
  end
end
