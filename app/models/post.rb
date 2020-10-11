class Post < ApplicationRecord
  mount_uploader :image, PostImageUploader

  belongs_to :user
  belongs_to :habit

  validates :content, presence: true, length: { maximum: 300 }
end
