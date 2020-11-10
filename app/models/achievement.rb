class Achievement < ApplicationRecord
  belongs_to :habit

  def self.already_save_achievement_today?(habit)
    today = Date.current.all_day
    achievement = habit.achievements.find_by(created_at: today)
    achievement.nil?
  end

  def start_time
    created_at
  end
end
