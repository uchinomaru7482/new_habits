FactoryBot.define do
  factory :post do
    sequence(:content) {|n| "テスト#{n}を行った"}
    association :habit
    user {habit.owner}
  end
end
