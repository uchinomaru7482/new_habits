FactoryBot.define do
  factory :habit do
    content "習慣登録テスト"
    record_type Habit::REPORT_TYPE
    association :owner
  end
end
