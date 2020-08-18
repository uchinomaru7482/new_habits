FactoryBot.define do
  factory :achievement do
    check true
    report 1
    association :habit
  end
end
