class ChallengeResult < ApplicationRecord
  belongs_to :user

  validates :total_questions, presence: true, numericality: { greater_than: 0 }
  validates :correct_answers, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
