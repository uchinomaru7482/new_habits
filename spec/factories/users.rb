FactoryBot.define do
  factory :user, aliases: [:owner] do
    sequence(:email) { |n| "tester#{n}@example.com" }
    sequence(:name) { |n| "tester#{n}" }
    admin false
    password "aaaaaaaa"
    password_confirmation "aaaaaaaa"
    confirmed_at Time.current
  end
end
