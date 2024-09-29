require 'rails_helper'

RSpec.describe QuizHistory, type: :model do
  # バリデーションのテスト
  describe 'バリデーションのテスト' do
    it 'すべての項目があれば有効であること' do
      quiz_history = build(:quiz_history)
      expect(quiz_history).to be_valid
    end

    it 'ユーザーの回答数がなければ無効であること' do
      quiz_history = build(:quiz_history, user_answer: nil)
      expect(quiz_history).to be_invalid
      expect(quiz_history.errors[:user_answer]).to include('を入力してください')
    end

    it 'ユーザーの回答数が0以上でなければ無効であること' do
      quiz_history = build(:quiz_history, user_answer: -1)
      expect(quiz_history).to be_invalid
      expect(quiz_history.errors[:user_answer]).to include('は0以上の値にしてください')
    end

    it '正答数がなければ無効であること' do
      quiz_history = build(:quiz_history, correct_answer: nil)
      expect(quiz_history).to be_invalid
      expect(quiz_history.errors[:correct_answer]).to include('を入力してください')
    end

    it '正答数が0以上でなければ無効であること' do
      quiz_history = build(:quiz_history, correct_answer: -1)
      expect(quiz_history).to be_invalid
      expect(quiz_history.errors[:correct_answer]).to include('は0以上の値にしてください')
    end

    it '正誤がtrueかfalseでなければ無効であること' do
      quiz_history = build(:quiz_history, is_correct: nil)
      expect(quiz_history).to be_invalid
      expect(quiz_history.errors[:is_correct]).to include('は一覧にありません')
    end

    it '回答日時がなければ無効であること' do
      quiz_history = build(:quiz_history, answered_at: nil)
      expect(quiz_history).to be_invalid
      expect(quiz_history.errors[:answered_at]).to include('を入力してください')
    end
  end

  # アソシエーションのテスト
  describe 'アソシエーションのテスト' do
    it 'userと関連付けられていること' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'location1と関連付けられていること' do
      association = described_class.reflect_on_association(:location1)
      expect(association.macro).to eq :belongs_to
    end

    it 'location2と関連付けられていること' do
      association = described_class.reflect_on_association(:location2)
      expect(association.macro).to eq :belongs_to
    end
  end
end
