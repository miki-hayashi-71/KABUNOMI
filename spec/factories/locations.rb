FactoryBot.define do
  factory :location do
    name { 'テスト地点' }

    latitude { 35.6895 }
    longitude { 139.6917 }

    trait :tokyo do
      name { '東京' }
      latitude { 35.6895 }
      longitude { 139.6917 }
    end

    trait :osaka do
      name { '大阪' }
      latitude { 34.6937 }
      longitude { 135.5023 }
    end
  end
end
