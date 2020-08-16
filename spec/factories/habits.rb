FactoryBot.define do
  factory :habit do
    content "毎日読書をする"
    record_type false
    association :owner
  end
end
