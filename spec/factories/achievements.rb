FactoryBot.define do
  factory :achievement do
    check true
    report 1
    association :habit
  end

  trait :created_at_yesterday do
    created_at 1.day.ago
  end

  trait :check_false do
    check false
    created_at 2.day.ago
  end
end
