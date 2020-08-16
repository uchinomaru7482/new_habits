FactoryBot.define do
  factory :post do
    content "今日は「具体と抽象」を読んだ"
    association :habit
    user {habit.owner}
  end
end
