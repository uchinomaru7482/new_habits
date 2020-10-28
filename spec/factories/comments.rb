FactoryBot.define do
  factory :comment do
    content "テストコメント"
    association :post
    user { post.user }
  end
end
