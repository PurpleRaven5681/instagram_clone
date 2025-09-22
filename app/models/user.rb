class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  
  # Подписки
  has_many :active_subscriptions, class_name: 'Subscription', 
                                  foreign_key: 'follower_id', 
                                  dependent: :destroy
  has_many :passive_subscriptions, class_name: 'Subscription', 
                                   foreign_key: 'following_id', 
                                   dependent: :destroy
  
  has_many :following, through: :active_subscriptions, source: :following
  has_many :followers, through: :passive_subscriptions, source: :follower
  
  # Аватар
  mount_uploader :avatar, AvatarUploader
  
  def follow(user)
    following << user unless self == user
  end
  
  def unfollow(user)
    following.delete(user)
  end
  
  def following?(user)
    following.include?(user)
  end
end
