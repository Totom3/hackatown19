class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  
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


  def create
    title = params[:title]
    if title.blank?
      send_error("Title cannot be blank.")
      return
    end
    
    description = params[:description][0..749]
    
    start = params[:start]
    if start.blank?
      send_error("Start time cannot be blank.")
      return
    end

    begin
      start = start.to_datetime
    rescue ArgumentError => e
      send_error("Invalid event start: #{e.message}")
      return
    end


    if params[:end].nil?
      end_e = nil
    else
      begin
	end_e = params[:end].to_datetime
      rescue ArgumentError => e
        send_error("Invalid event end: #{e.message}")
	return
      end
      if end_e < start
        send_error("End cannot be before start")
        return
      end
    end

    organizer = User.find_by(id: params[:organizer])
    if organizer.nil?
      send_error("No such user '#{params[:organizer]}'")
      return
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
    
    render json: @event
  end

  def comment
  end

  def join
  end

  def leave
  end


  private

  def send_error(msg, status = :bad_request)
    render json: {error_message: msg}, status: status
  end
end
