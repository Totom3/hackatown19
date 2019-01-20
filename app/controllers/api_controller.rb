class ApiController < ApplicationController
  
  include LoginUtils
 
  def event
    render json: Event.find_by(params[:id]), except: [:event_participants, :event_tags]
  end

  def search
    query = params[:query].split(' ')
    puts query.join(':')

    @events = nil
    query.each do |w|
      res = Event.where('title LIKE ?', "%#{w}%").or(Event.where('description LIKE ?', "%#{w}%"))
      @events = (if @events.nil? then res else @events.or(res) end)
    end

    render json: @events
  end

  def join_event
    user = get_current_user
    if user.nil?
      send_error("Must be logged in.")
      return
    end

    event = Event.find_by(id: params[:event_id])
    if event.nil?
      send_error("Invalid event ID '#{params[:event_id]}'")
      return
    end

    rec = EventParticipant.find_by(user: user, event: event)
    if not rec.nil?
      success = false
      message = "Already joined the event."
    else
      success = true
      message = "Successfully joined the event."
	  EventParticipant.create(user: user, event: event)
    end

    render json: {
      success: success,
      message: message
    }

  end

  def leave_event
    user = get_current_user
      if user.nil?
        send_error("Must be logged in.")
    	return
      end
    
    event = Event.find_by(id: params[:event_id])
    if event.nil?
      send_error("Invalid event ID '#{params[:event_id]}'")
      return
    end
    
    rec = EventParticipant.find_by(user: user, event: event)
    if rec.nil?
      success = false
      message = "Not a part of the event."
    else
      success = true
      message = "Successfully left the event."
	  rec.destroy
    end

    render json: {
      success: success,
      message: message
    }, status: :ok
  end

  def create
    organizer = get_current_user
    if organizer.nil?
      send_error("Must be logged in.")
      return
    end

    title = params[:title]
    if title.blank?
      send_error("Title cannot be blank.")
      return
    end
    
    description = params[:description][0..749]
    
    start = get_date_str(params[:start])
    if start.blank?
      send_error("Start time cannot be blank.")
      return
    end

    begin
      start = start.to_datetime
    rescue ArgumentError
      send_error("Invalid event start: #{start}")
      return
    end

    
    _e = get_date_str(params[:end])
    if _e.nil?
      end_e = nil
    else
      begin
	end_e = _e.to_datetime
      rescue ArgumentError
        send_error("Invalid event end: #{_e}")
        return
      end
      if end_e < start
        send_error("End cannot be before start")
        return
      end
    end

    location = params[:location]
    if location.blank?
      send_error("Location cannot be blank")
      return
    end

    # Create event
    @event = Event.create(title: title,
                 description: description,
		 start: start,
		 end: end_e,
		 organizer: organizer,
		 location: location)
    
    # Add organizer to event
    EventParticipant.create(event: @event, user: organizer)

    render json: @event
  end

  def prefs
    user = get_current_user
    if user.nil?
      send_error("Must be logged in.")
      return
    end

    errors = []

    tags_arr = params[:tags]
    if tags_arr.present?
      UserSubscription.where(user: user).destroy_all
      tags_arr.downcase.split(',').each do |t|
        tag = Tag.find_by(name: t.strip)
	if tag.nil?
	  errors.push("Invalid tag '#{t.strip}'")
	else
          UserSubscription.create(user: user, tag: tag)
	end
      end
    end
    
    new_dist = params[:max_distance]
    if new_dist.present?
      dist = [0, new_dist.to_f].max
      user.max_distance = dist
      user.save
    end

    render json: {message: "Updated profile.", errors: errors}, status: :accepted
  end


  private

  def send_error(msg, status = :bad_request)
    render json: {error_message: msg}, status: status
  end

  def get_date_str(d)
    if d.is_a?(String)
      return d
    end

    if d.is_a?(ActionController::Parameters)
      return "#{d['0']}-#{d['1']}-#{d['2']} #{d['3']}:#{d['4']}:00"
    end

    return d
  end
end
