require 'rails_helper'

RSpec.describe QuizHistory, type: :model do

  # バリデーションのテスト
  describe 'バリデーションのテスト' do

    it '全ての項目があれば有効であること' do
      quiz_history = build(:quiz_history)
      expect(quiz_history).to be_valid
    end

    it 'user_answerがなければ無効であること' do
      quiz_history = build(:quiz_history, user_answer: nil)
      expect(quiz_history).to be_invalid
      expect(quiz_history.errors[:user_answer]).to include('を入力してください')
    end

    it 'user_answerが0以上でなければ無効であること' do
      quiz_history = build(:quiz_history, user_answer: -1)
      expect(quiz_history).to be_invalid
      expect(quiz_history.errors[:user_answer]).to include('は0以上の値にしてください')
    end

    it 'correct_answerがなければ無効であること' do
      quiz_history = build(:quiz_history, correct_answer: nil)
      expect(quiz_history).to be_invalid
      expect(quiz_history.errors[:correct_answer]).to include('を入力してください')
    end

    it 'correct_answerが0以上でなければ無効であること' do
      quiz_history = build(:quiz_history, correct_answer: -1)
      expect(quiz_history).to be_invalid
      expect(quiz_history.errors[:correct_answer]).to include('は0以上の値にしてください')
    end

    it 'is_correctがtrueかfalseでなければ無効であること' do
      quiz_history = build(:quiz_history, is_correct: nil)
      expect(quiz_history).to be_invalid
      expect(quiz_history.errors[:is_correct]).to include('は一覧にありません')
    end

    it 'modeがなければ無効であること' do
      quiz_history = build(:quiz_history, mode: nil)
      expect(quiz_history).to be_invalid
      expect(quiz_history.errors[:mode]).to include('を入力してください')
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
