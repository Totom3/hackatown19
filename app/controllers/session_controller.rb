class SessionController < ApplicationController
  include LoginUtils
  
  def login
    if has_current_user
      redirect_to '/hi'
    end
  end

  def create
    if params[:session]
      email = params[:session][:email]
      password = params[:session][:password]
    else
      email = params[:email]
      password = params[:password]
    end

    if login_user(email, password)
      redirect_to '/hi'
    else
      flash.now[:notice] = 'Invalid email/password.'
      render 'login'
    end

  end

  def destroy
    logout_user
    if has_current_user
      flash[:notice] = 'Successfully logged out.'
    end

    redirect_to '/hi'
  end

  def hi
    @user = get_current_user
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

    render json: {
      message: "Successfully created user.",
      user: user
    }, status: :accepted
  end

  private

  def send_error(msg, status = :bad_request)
    render json: {error: msg, status: status}
  end
end
