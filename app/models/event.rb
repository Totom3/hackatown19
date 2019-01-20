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
     
     tags_str = tags.map{|t| t.name}.join(', ')
     j[:tags] = tags_str


     intr = Hash.new
     UserSubscription.all.each do |sub|
       if sub.user.id and tags.exists?(sub.tag.id) and not participants.exists?(sub.user.id)
         intr[sub.user.id] = true
       end
     end

     puts "Interested: " + intr.to_json
     puts "(#{intr.size})"
     
     j[:interested] = intr.size

     return j
  end
end
