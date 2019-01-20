module LoginUtils
	
  def get_current_user
    User.find_by(id: session[:current_user_id])
  end

  def has_current_user
    get_current_user.present?
  end

  def login_user(email, pass)
    user = User.find_by(email: email)
    if user and user.password == pass
      session[:current_user_id] = user.id
      return user
    end

    return nil
  end

  def set_current_user(id)
    session[:current_user_id] = id
  end

  def logout_user
    session.delete(:current_user_id)
  end
end
