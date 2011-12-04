class ApplicationController < ActionController::Base
  protect_from_forgery

  def admin_required
    return true if user_signed_in? and current_user.admin?
    session[:return_to] = request.request_uri
    redirect_to root_url, 
             :alert => 
             "You must be an administrator to do this!" and return false
  end

end
