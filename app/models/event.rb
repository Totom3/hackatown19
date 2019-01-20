class Event < ApplicationRecord
  belongs_to :organizer, class_name: 'User', foreign_key: 'user_id'
  has_many :event_tags
  has_many :event_participants
  has_many :tags, through: :event_tags
  has_many :participants, through: :event_participants, source: 'user'

  def as_json(options={})
     j = super.as_json(options)
     j[:start] = start.strftime("%B %d, %Y at %H:%M")
     j[:interested] = 2
     j[:participants] = participants.size
     return j
  end
end
