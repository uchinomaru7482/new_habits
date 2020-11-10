FactoryBot.define do
  factory :user, aliases: [:owner] do
    sequence(:email) { |n| "tester#{n}@example.com" }
    sequence(:name) { |n| "tester#{n}" }
    password "aaaaaaaa"
    password_confirmation "aaaaaaaa"
    confirmed_at Time.current
  end
end
