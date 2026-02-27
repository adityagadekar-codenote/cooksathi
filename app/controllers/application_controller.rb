class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_authentication
    return if logged_in?
    redirect_to login_path, alert: 'Please log in to continue.'
  end

  def require_ownership(resource)
    return if current_user == resource.user
    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end
end
