FactoryBot.define do
  factory :habit do
    content "習慣登録テスト"
    record_type false
    association :owner
  end
end
