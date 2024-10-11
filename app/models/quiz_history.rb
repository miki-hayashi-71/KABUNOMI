class QuizHistory < ApplicationRecord
  belongs_to :user
  # ランダムで取得した2つのLocationを1と2に分けて関連付ける
  belongs_to :location1, class_name: 'Location'
  belongs_to :location2, class_name: 'Location'

  validates :user_answer, presence: true, numericality: { greater_than_or_equal_to: 0 } # ユーザーが選択した距離が0以上の数値であること
  validates :correct_answer, presence: true, numericality: { greater_than_or_equal_to: 0 } # 正答の距離が0以上の数値であること
  validates :is_correct, inclusion: { in: [true, false] } # trueかfalse以外は不可
  validates :mode, presence: true

end
