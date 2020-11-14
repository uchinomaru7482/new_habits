FactoryBot.define do
  factory :habit do
    content "習慣登録テスト"
    report_type Habit::REPORT_TYPE
    report_unit "時間"
    association :owner
  end
end
