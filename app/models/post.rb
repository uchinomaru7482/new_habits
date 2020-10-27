class Post < ApplicationRecord
  mount_uploader :image, PostImageUploader

  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :habit

  validates :content, presence: true, length: { maximum: 300 }
end
