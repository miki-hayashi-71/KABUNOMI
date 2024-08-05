class Location < ApplicationRecord
  # userモデル:locationモデル＝1:多
  belongs_to :user

  # 入力必須（名称、緯度、経度）
  validates :name, presence: true, length: { maximum: 255 }
  validates :latitude, presence: true
  validates :longitude, presence: true

  # 住所は任意だが、入力されている場合は最大長を指定
  validates :address, length: { maximum: 255 }, allow_blank: true
end
