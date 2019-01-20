class User < ApplicationRecord
  has_many :user_subscriptions
  has_many :tags, through: :user_subscriptions
end
