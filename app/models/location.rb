class Location < ApplicationRecord

  # 入力必須（名称、緯度、経度）
  validates :name, presence: true, length: { maximum: 255 }
  validates :latitude, presence: true
  validates :longitude, presence: true

end
