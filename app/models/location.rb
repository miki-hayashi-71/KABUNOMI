class Location < ApplicationRecord
  # locationをquiz_historiesのlocation1とlocation2として、複数関連付ける
  has_many :quiz_histories_as_location1, class_name: 'QuizHistory', foreign_key: 'location1_id'
  has_many :quiz_histories_as_location2, class_name: 'QuizHistory', foreign_key: 'location2_id'

  # 入力必須（名称、緯度、経度）
  validates :name, presence: true, length: { maximum: 255 }
  validates :latitude, presence: true
  validates :longitude, presence: true

end
