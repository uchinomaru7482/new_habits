class Habit < ApplicationRecord
  CHECK_TYPE = true
  REPORT_TYPE = false

  belongs_to :owner, class_name: "User", foreign_key: :user_id, inverse_of: :habits
  has_many :posts, dependent: :destroy
  has_many :achievements, dependent: :destroy

  validates :content, presence: true, length: { maximum: 40 }
  validates :report_type, inclusion: { in: [true, false] }
  validates :report_unit, presence: true, length: { maximum: 8 }

  def calculation_management_value
    self.total_days = count_total_days
    self.continuation_days = count_continuation_days
    self.total_report = count_total_report if report_type == REPORT_TYPE
    save
  end

  def count_total_days
    Achievement.where(habit_id: id).where(check: true).count
  end

  def count_continuation_days
    day = Date.current.all_day
    achievement = achievements.find_by(created_at: day)
    count_days = 0
    n = 0
    while achievement && achievement.check == true
      count_days += 1
      n += 1
      day = (Date.current - n).all_day
      achievement = achievements.find_by(created_at: day)
    end
    count_days
  end

  def count_total_report
    report = 0
    achievements.each do |achievement|
      report += achievement.report
    end
    report
  end
end
