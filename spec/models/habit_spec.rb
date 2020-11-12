require "rails_helper"

RSpec.describe Habit, type: :model do
  it "is valid with a content and record_type" do
    user = FactoryBot.create(:user)
    habit = Habit.new(
      content: "毎日読書をする",
      record_type: Habit::REPORT_TYPE,
      user_id: user.id
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

  it "is invalid without a report_unit more than the maximum characters" do
    habit = FactoryBot.build(:habit, report_unit: "x" * 9)
    habit.valid?
    expect(habit.errors[:report_unit]).to include("は8文字以内で入力してください")
  end

  it "returns total days" do
    achievement = FactoryBot.create(:achievement)
    habit = achievement.habit
    FactoryBot.create(:achievement, :created_at_yesterday, habit: habit)
    FactoryBot.create(:achievement, :check_false, habit: habit)
    expect(habit.count_total_days).to eq 2
  end

  it "returns continuation days" do
    habit = FactoryBot.create(:habit, continuation_days: 1)
    FactoryBot.create(:achievement, :created_at_yesterday, habit: habit)
    FactoryBot.create(:achievement, habit: habit)
    expect(habit.count_continuation_days).to eq 2
  end

  it "return the reset continuation days" do
    habit = FactoryBot.create(:habit, continuation_days: 3)
    FactoryBot.create(:achievement, habit: habit)
    expect(habit.count_continuation_days).to eq 1
  end

  it "return the count total time" do
    habit = FactoryBot.create(:habit)
    FactoryBot.create(:achievement, :created_at_yesterday, habit: habit)
    FactoryBot.create(:achievement, habit: habit)
    expect(habit.count_total_time).to eq 2
  end
end
