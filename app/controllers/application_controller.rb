class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :update_sanitized_params, if: :devise_controller?
  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit( :username,:email, :password)}
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit( :username, :password, :password_confirmation, :current_password) }
  end
  include TheRoleController
  def access_denied
    render :text => 'access_denied: requires an role' and return
  end
  alias_method :login_required,
               :authenticate_user!
  alias_method :role_access_denied, :access_denied

  require 'emoticon_fontify'


  def findImage(content)
    condition = /(<img)(.*?)(>)/.match(content)
    if(condition)
      image = condition[0].scan(/(src=")(.*?)(")/)
      return image[0][1]
    else
      return "0"
    end
  end
  helper_method :findImage




end


