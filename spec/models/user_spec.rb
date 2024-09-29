require 'rails_helper'

RSpec.describe User, type: :model do

  # バリエーションのテスト
  describe 'バリデーションのテスト' do

    it '全ての項目があれば有効であること' do
      user = build(:user) # データベースに保存せずオブジェクトを作成するメソッド(保存する時はcreate)
      expect(user).to be_valid
    end

    it 'nameがなければ無効であること' do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors[:name]).to include('を入力してください')
    end

    it 'emailがなければ無効であること' do
      user = build(:user, email: nil)
      expect(user).to be_invalid
      expect(user.errors[:email]).to include('を入力してください')

    end

    it 'passwordがなければ無効であること' do
      user = build(:user, password: nil, password_confirmation: nil)
      expect(user).to be_invalid
      expect(user.errors[:password]).to include('を入力してください')
    end

    it 'nameが255文字以下であること' do
      user = build(:user, name: 'a' * 256)
      expect(user).to be_invalid
      expect(user.errors[:name]).to include('は255文字以内で入力してください')
    end

    it 'passwordが3文字以上であること' do
      user = build(:user, password: '12', password_confirmation: '12')
      expect(user).to be_invalid
      expect(user.errors[:password]).to include('は3文字以上で入力してください')
    end

    it 'emailがユニークであること' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).to be_invalid
      expect(user.errors[:email]).to include('はすでに存在します')
    end

    it 'passwordとpassword_confirmationが一致すること' do
      user = build(:user, password: 'password', password_confirmation: 'different_password')
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
    end

  end

  # アソシエーションのテスト
  describe 'アソシエーションのテスト' do

    it 'quiz_hisroriesを持っていること' do
      association = described_class.reflect_on_association(:quiz_histories)
      expect(association.macro).to eq :has_many
    end

    it 'challenge_resultsを持っていること' do
      association = described_class.reflect_on_association(:challenge_results)
      expect(association.macro).to eq :has_many
    end

  end
end
