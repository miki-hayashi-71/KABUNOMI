FactoryBot.define do
  factory :challenge_result do
    user
    total_questions { 10 }
    correct_answers { 7 }
  end
end
