require 'rails_helper'

RSpec.describe Habit, type: :model do
  it "is valid with a content and record_type" do
  	user = FactoryBot.create(:user)
  	habit = Habit.new(
  	  content: "毎日読書をする",
  	  record_type: false,
  	  user_id: user.id,
  	)
  	expect(habit).to be_valid
  end

  it "is invalid without a content" do
  	habit = FactoryBot.build(:habit, content: nil)
  	habit.valid?
  	expect(habit.errors[:content]).to include("を入力してください")
  end

  it "is invalid with a content more than the maximum characters" do
    habit = FactoryBot.build(:habit, content: "x" * 41)
    habit.valid?
    expect(habit.errors[:content]).to include("は40文字以内で入力してください")
  end

  it "is invalid without a record_type" do
  	habit = FactoryBot.build(:habit, record_type: nil)
  	habit.valid?
  	expect(habit.errors[:record_type]).to include("は一覧にありません")
  end
end
