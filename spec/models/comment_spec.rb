require "rails_helper"

RSpec.describe Comment, type: :model do
  it "is valid with a content" do
    post = FactoryBot.create(:post)
    Comment.new(
      content: "テストコメント",
      post_id: post.id,
      user_id: post.user_id
    )
    expect(post).to be_valid
  end

  it "is invalid without a content" do
    comment = FactoryBot.build(:comment, content: nil)
    comment.valid?
    expect(comment.errors[:content]).to include("を入力してください")
  end
end
