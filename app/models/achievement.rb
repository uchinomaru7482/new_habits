class Achievement < ApplicationRecord
  belongs_to :habit

  def self.already_save_achievement_today?(habit)
    achievement = Achievement.find_by(habit_id: habit.id, created_at: Time.current.all_day)
    achievement.nil?
  end

  def start_time
    created_at
  end
end
