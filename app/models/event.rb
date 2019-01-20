class Event < ApplicationRecord
  belongs_to :organizer, class_name: 'User', foreign_key: 'user_id'
  has_many :event_tags
  has_many :event_participants
  has_many :tags, through: :event_tags
  has_many :participants, through: :event_participants, source: 'user'
end
