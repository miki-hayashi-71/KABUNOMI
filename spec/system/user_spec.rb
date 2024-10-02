require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do

  before do
    visit new_user_path
  end


  it '正しいタイトルが表示されていること' do
    expect(page).to have_content('新規ユーザー登録'), 'ユーザー登録ページに「新規ユーザー登録」と表示されていません。'
  end

  context '入力情報正常系' do
    it 'ユーザーが新規作成できること' do
      fill_in 'user_name', with: 'テストユーザー'
      fill_in 'user_email', with: 'test@example.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_on '登録'
      expect(page).to have_content('ユーザー登録に成功しました'), 'フラッシュメッセージ「ユーザー登録に成功しました」が表示されていません'
    end
  end


  context '入力情報異常系' do

    it 'ユーザーが新規作成できない' do
      fill_in 'user_name', with: ''
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: ''
      fill_in 'user_password_confirmation', with: ''
      click_on '登録'
      expect(page).to have_content('ユーザー登録に失敗しました'), 'フラッシュメメッセージ「ユーザー登録に成功しました」が表示されていません'
    end

    it 'パスワードとパスワード確認が一致しない場合、エラーメッセージが表示される' do
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'mismatch'
      click_on '登録'
      expect(page).to have_content('ユーザー登録に失敗しました'), 'フラッシュメメッセージ「ユーザー登録に成功しました」が表示されていません'
    end

    it 'パスワードが3文字未満の場合、エラーメッセージが表示される' do
      fill_in 'user_password', with: 'pw'
      fill_in 'user_password_confirmation', with: 'pw'
      click_on '登録'
      expect(page).to have_content('ユーザー登録に失敗しました'), 'フラッシュメメッセージ「ユーザー登録に成功しました」が表示されていません'
    end

  end
end
