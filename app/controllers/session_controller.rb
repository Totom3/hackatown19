class SessionController < ApplicationController
  include LoginUtils
 
  def main
    render 'main'
  end;

  def create
    if params[:session]
      email = params[:session][:email]
      password = params[:session][:password]
    else
      email = params[:email]
      password = params[:password]
    end

    if login_user(email, password)
      redirect_to '/'
    else
      redirect_to '/?failed_login=1'
    end

  end

  def destroy
    logout_user
    if has_current_user
      flash[:notice] = 'Successfully logged out.'
    end

    redirect_to '/'
  end

  def hi
    @user = get_current_user
    render json: {
      user: (if @user.nil? then nil else @user.id end)
    }
  end

  def signup
    email = params[:email]
    if email.blank?
      send_error("Email cannot be blank.")
      return
    end
    email = email.downcase

    name = params[:name]
    if name.blank?
      send_error("Name cannot be blank.")
      return
    end

    password = params[:password]
    if password.blank?
      send_error("Password cannot be blank.")
      return
    end

    location = params[:location]
    if location.blank?
      send_error("Location cannot be blank.")
      return
    end

    max_distance = params[:max_distance]
    max_distance = if max_distance.nil? then 0 else [0, max_distance.to_f].max end

    user = User.create(name: name,
                email: email,
		password: password,
		location: location,
		max_distance: max_distance)

    if params[:tags].present?
      it = nil
      if params[:tags].is_a?(ActionController::Parameters)
        it = params[:tags].keys
      else
        it = params[:tags].split(',')
      end

      it.each do |t|
        t = t.downcase.strip
	    tag = Tag.find_by(name: t)
        if not tag.nil?
          puts "Adding tag #{t}"
		  UserSubscription.create(user: user, tag: tag)
        else
		  puts "Invalid tag #{t}!"
		end
      end
    end
		
    set_current_user(user.id)
    redirect_to '/'
  end

  private

  def send_error(msg, status = :bad_request)
    render json: {error: msg, status: status}
  end
end
