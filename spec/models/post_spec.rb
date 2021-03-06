require "rails_helper"

RSpec.describe Post, type: :model do
  it "is valid with a content" do
    habit = FactoryBot.create(:habit)
    post = Post.new(
      content: "今日は「具体と抽象」を読んだ",
      habit_id: habit.id,
      user_id: habit.user_id
    )
    expect(post).to be_valid
  end

  it "is invalid without a content" do
    post = FactoryBot.build(:post, content: nil)
    post.valid?
    expect(post.errors[:content]).to include("を入力してください")
  end
end
