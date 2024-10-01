require 'rails_helper'

RSpec.describe 'マイページ', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  before do
    # ログイン処理
    login_as(user)
  end

  describe 'マイページの表示' do
    before do
      visit mypage_path
    end

    it 'ユーザーの情報が正しく表示されていること' do
      expect(page).to have_content('マイページ')
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
    end

    it '編集ページへのリンクが表示されていること' do
      expect(page).to have_link('編集', href: edit_mypage_path)
    end
  end

  describe 'マイページの編集' do
    before do
      visit edit_mypage_path
    end

    it 'マイページの編集画面が表示されていること' do
      expect(page).to have_content('マイページ編集')
      expect(page).to have_field('user_name', with: user.name)
      expect(page).to have_field('user_email', with: user.email)
    end

    context '更新処理' do
      it '正しい情報で更新した場合、更新に成功し、マイページにリダイレクトされること' do
        fill_in 'user_name', with: '新しい名前'
        fill_in 'user_email', with: 'newemail@example.com'
        click_button '更新'

        expect(page).to have_content('ユーザー情報を更新しました')
        expect(page).to have_content('新しい名前')
        expect(page).to have_content('newemail@example.com')
        expect(page).to have_current_path(mypage_path)
      end

      it '不正な情報で更新した場合、エラーメッセージが表示されること' do
        fill_in 'user_name', with: ''
        fill_in 'user_email', with: ''
        click_button '更新'

        expect(page).to have_content('ユーザー情報を更新できませんでした')
      end
    end
  end
end
