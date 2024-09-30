require 'rails_helper'

RSpec.describe "トップページ", type: :system do

  context 'ヘッダー' do

    before do
      visit root_path
    end

    describe 'ログイン前' do
      it 'ヘッダーが正しく表示されていること' do
        expect(page).to have_content('ログイン'), 'ヘッダーに「ログイン」というテキストが表示されていません'
        expect(page).to have_content('新規登録'), 'ヘッダーに「新規登録」というテキストが表示されていません'
      end
    end

    describe 'ログイン後' do
      let(:user){create(:user)}

      before do
        login_as(user)
      end

      it 'ヘッダーが正しく表示されていること' do
        expect(page).to have_content('マイページ'), 'ヘッダーに「マイページ」というテキストが表示されていません'
        expect(page).to have_content('ログアウト'), 'ヘッダーに「ログアウト」というテキストが表示されていません'
      end
    end

  end

  context 'フッター' do

    before do
      visit root_path
    end

    it 'フッターが正しく表示されていること' do
      expect(page).to have_content('利用規約'), 'フッターに「利用規約」というテキストが表示されていません'
      expect(page).to have_content('プライバシーポリシー'), 'フッターに「プライバシーポリシー」というテキストが表示されていません'
      expect(page).to have_content('お問い合わせ'), 'フッターに「お問い合わせ」というテキストが表示されていません'
      expect(page).to have_css('i.fa-x-twitter'), 'フッターに「X」のアイコンが表示されていません'
      expect(page).to have_css('i.fa-github'), 'フッターに「GitHub」のアイコンが表示されていません'
    end

    it '利用規約ページに遷移できること' do
      click_link '利用規約'
      expect(page).to have_current_path(terms_of_service_path)
    end

    it 'プライバシーポリシーページに遷移できること' do
      click_link 'プライバシーポリシー'
      expect(page).to have_current_path("https://kiyac.app/privacypolicy/XxakzkL5Hxiv01Ka9WOG", url: true)
    end

    it 'お問い合わせページに遷移できること' do # 短縮系で実装しているが、テストでは正規のURLで遷移を確認
      click_link 'お問い合わせ'
      expect(page.current_url).to include('https://docs.google.com/forms/d/e/1FAIpQLSdU1KArHAoMY1sAZsvQK7xrJLhcAmBFXPArby2tyACsZj6-IQ/viewform')
    end

  end
end
