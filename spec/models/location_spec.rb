require 'rails_helper'

RSpec.describe Location, type: :model do

  # バリエーションのテスト
  describe 'バリデーションのテスト' do

    it '名称、緯度、経度があれば有効であること' do
      location = build(:location)
      expect(location).to be_valid
    end

    it '名称がなければ無効であること' do
      location = build(:location, name: nil)
      expect(location).to be_invalid
      expect(location.errors[:name]).to include('を入力してください')
    end

    it '名称が255文字を超えると無効であること' do
      location = build(:location, name: 'a' * 256)
      expect(location).to be_invalid
      expect(location.errors[:name]).to include('は255文字以内で入力してください')
    end

    it '緯度がなければ無効であること' do
      location = build(:location, latitude: nil)
      expect(location).to be_invalid
      expect(location.errors[:latitude]).to include('を入力してください')
    end

    it '経度がなければ無効であること' do
      location = build(:location, longitude: nil)
      expect(location).to be_invalid
      expect(location.errors[:longitude]).to include('を入力してください')
    end

  end

  # アソシエーションのテスト
  describe 'アソシエーションのテスト' do

    it 'quiz_histories_as_location1と関連付けられていること' do
      association = described_class.reflect_on_association(:quiz_histories_as_location1)
      expect(association.macro).to eq :has_many
    end

    it 'quiz_histories_as_location2と関連付けられていること' do
      association = described_class.reflect_on_association(:quiz_histories_as_location2)
      expect(association.macro).to eq :has_many
    end
  end
end
