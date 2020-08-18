require 'rails_helper'

RSpec.describe Achievement, type: :model do
  it "is valid with a check and report" do
  	habit = FactoryBot.create(:habit)
  	achievement = Achievement.new(
  	  check: true,
  	  report: 3,
  	  habit_id: habit.id,
  	)
  end
end
