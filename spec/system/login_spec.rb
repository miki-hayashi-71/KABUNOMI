require 'rails_helper'

RSpec.describe 'ログイン機能', type: :system do
  let!(:user) { FactoryBot.create(:user, email: 'test@example.com', password: 'password') }

  before do
    visit login_path
  end

  context 'ログイン画面の表示' do
    it 'ログインページが正しく表示されること' do
      expect(page).to have_content('ログイン'), 'ログインページに「ログイン」と表示されていません'
    end
  end

  context '入力情報正常系' do
    it '正しい情報を入力するとログインできること' do
      fill_in 'email', with: 'test@example.com'
      fill_in 'password', with: 'password'
      within('form[action="/login"]') do # フォーム内の「ログイン」ボタンをクリック
        click_on 'ログイン'
      end
      expect(page).to have_content('ログインに成功しました'), 'フラッシュメッセージ「ログインに成功しました」が表示されていません'
      expect(page).to have_current_path(root_path), 'ログイン後にトップページへ遷移していません'
    end
  end

  context '入力情報異常系' do

    it 'メールアドレスが間違っている場合、ログインに失敗すること' do
      fill_in 'email', with: 'wrong@example.com'
      fill_in 'password', with: 'password'
      within('form[action="/login"]') do
        click_on 'ログイン'
      end
      expect(page).to have_content('ログインに失敗しました'), 'フラッシュメッセージ「ログインに失敗しました」が表示されていません'
      expect(page).to have_current_path(login_path), 'ログインに失敗後、ログインページに留まっていません'
    end

    it 'パスワードが間違っている場合、ログインに失敗すること' do
      fill_in 'email', with: 'test@example.com'
      fill_in 'password', with: 'wrongpassword'
      within('form[action="/login"]') do
        click_on 'ログイン'
      end
      expect(page).to have_content('ログインに失敗しました'), 'フラッシュメッセージ「ログインに失敗しました」が表示されていません'
      expect(page).to have_current_path(login_path), 'ログインに失敗後、ログインページに留まっていません'
    end

    it 'メールアドレスとパスワードが空の場合、ログインに失敗すること' do
      fill_in 'email', with: ''
      fill_in 'password', with: ''
      within('form[action="/login"]') do
        click_on 'ログイン'
      end
      expect(page).to have_content('ログインに失敗しました'), 'フラッシュメッセージ「ログインに失敗しました」が表示されていません'
      expect(page).to have_current_path(login_path), 'ログインに失敗後、ログインページに留まっていません'
    end
  end

  context 'ログアウト' do
    it 'ログアウトができること' do
      fill_in 'email', with: 'test@example.com'
      fill_in 'password', with: 'password'
      within('form[action="/login"]') do
        click_on 'ログイン'
      end
      click_on 'ログアウト', id: 'logout-link' # テストを通すためにidを追加
      expect(page).to have_content('ログアウトしました'), 'フラッシュメッセージ「ログアウトしました」が表示されていません。'
      expect(page).to have_current_path(root_path), 'ログアウト後、トップページへ遷移していません。'
    end
  end
end
