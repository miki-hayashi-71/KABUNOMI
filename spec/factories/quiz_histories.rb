FactoryBot.define do
  factory :quiz_history do
    user
    association :location1, factory: :location
    association :location2, factory: :location
    user_answer { 100 }
    correct_answer { 120 }
    is_correct { false }
    mode { simple }
  end
end
