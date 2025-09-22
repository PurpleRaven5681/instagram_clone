class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  
  mount_uploader :image, ImageUploader
  
  validates :image, presence: true
  validates :caption, length: { maximum: 2200 }
  
  # Для поиска
  def self.ransackable_attributes(auth_object = nil)
    ["caption", "created_at", "id", "updated_at", "user_id"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["user", "likes", "likers"]
  end
end

