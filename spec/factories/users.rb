FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    sequence(:email) { |n| "test_#{n}@example.com" } # データが重複しないことを防ぐ設定
    password { 'password' }
    password_confirmation { 'password' }
  end
end
