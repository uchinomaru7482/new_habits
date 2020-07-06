class Post < ApplicationRecord
  belongs_to :user
  belongs_to :habit
  
  validates :content, presence: true, length: {maximum: 300}
end
