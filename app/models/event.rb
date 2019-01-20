class Event < ApplicationRecord
  belongs_to :organizer, class_name: 'User', foreign_key: 'user_id'
  has_many :event_tags
  has_many :event_participants
  has_many :tags, through: :event_tags
  has_many :participants, through: :event_participants, source: 'user'

  def as_json(options={})
     j = super.as_json(options)
     j[:start] = start.strftime("%B %d, %Y at %H:%M")
     j[:participants] = participants.size
     
     tags_str = tags.join(', ')
     j[:tags] = tags_str


     intr = []
     UserSubscriptions.where("tag IN ?", "(#{tags_str})").each do |sub|
       intr[sub.user.id] = true
     end

     j[:interested] = intr.keys.size

     return j
  end
end
