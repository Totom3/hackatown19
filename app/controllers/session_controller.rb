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
end
