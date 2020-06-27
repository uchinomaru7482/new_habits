class Habit < ApplicationRecord
	belongs_to :user

	validates :habit_content, presence: true, length: {maximum: 100}
	validates :habit_type, presence: true
	validates :open_range, presence: true, numericality: {less_than_or_equal_to: 2}
end
