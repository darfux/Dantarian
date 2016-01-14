class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  protected
    def authenticate_user!
      unless User.find_by_id(session[:user_id])
        redirect_to login_url
      end
    end

    def current_user
      @current_user ||= session[:user_id] && User.find(session[:user_id])
    end
end
