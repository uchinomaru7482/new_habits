FactoryBot.define do
  factory :user, aliases: [:owner] do
    sequence(:email) {|n| "tester#{n}@example.com"}
    name "shun"
    password "aaaaaaaa"
    password_confirmation "aaaaaaaa"
  end
end
