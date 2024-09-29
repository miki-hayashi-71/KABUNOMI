require 'rails_helper'

RSpec.describe ChallengeResult, type: :model do
  # バリデーションのテスト
  describe 'バリデーションのテスト' do

    it '全ての項目があれば有効であること' do
      challenge_result = build(:challenge_result)
      expect(challenge_result).to be_valid
    end

    it 'total_questionsがなければ無効であること' do
      challenge_result = build(:challenge_result, total_questions: nil)
      expect(challenge_result).to be_invalid
      expect(challenge_result.errors[:total_questions]).to include('を入力してください')
    end

    it 'total_questionsが0以下だと無効であること' do
      challenge_result = build(:challenge_result, total_questions: 0)
      expect(challenge_result).to be_invalid
      expect(challenge_result.errors[:total_questions]).to include('は0より大きい値にしてください')
    end

    it 'correct_answersがなければ無効であること' do
      challenge_result = build(:challenge_result, correct_answers: nil)
      expect(challenge_result).to be_invalid
      expect(challenge_result.errors[:correct_answers]).to include('を入力してください')
    end

    it 'correct_answersが0未満だと無効であること' do
      challenge_result = build(:challenge_result, correct_answers: -1)
      expect(challenge_result).to be_invalid
      expect(challenge_result.errors[:correct_answers]).to include('は0以上の値にしてください')
    end
  end

  # アソシエーションのテスト
  describe 'アソシエーションのテスト' do

    it 'userと関連付けられていること' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

  end
end
