class Habit < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  has_many :posts, dependent: :destroy
  has_many :achievements, dependent: :destroy

  validates :content, presence: true, length: { maximum: 40 }
  validates :record_type, inclusion: { in: [true, false] }
  #validates :open_range, presence: true, numericality: {less_than_or_equal_to: 2}

  def count_total_days
    Achievement.where(habit_id: self.id).where(check: true).count
  end

  def count_continuation_days
    yesterday = (Date.current - 1).all_day
    if self.achievements.find_by(created_at: yesterday)
      self.continuation_days + 1
    else
      1
    end
  end

  def count_total_time
  	time = 0
    self.achievements.each do |achievement|
      time += achievement.report
    end
    time
  end
end
