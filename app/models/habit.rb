class Habit < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_many :achievements, dependent: :destroy

  validates :content, presence: true, length: {maximum: 100}
  validates :record_type, inclusion: {in: [true, false]}
  #validates :open_range, presence: true, numericality: {less_than_or_equal_to: 2}
end