class User::SessionController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :create_by_token]
  def new
    @session = User::Session.new
  end

  def create
    session_params = params[:user_session]
    @user = User.find_by(account: session_params[:account])
    if @user && @user.authenticate(session_params[:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def create_by_token
    token = User::Token.parse(params[:token])
    if token
      session[:user_id] = token.user_id
      Rails.cache.write({token: token.to_s}, true)
      redirect_to token.target_path || root_path
    else
      render 'invalid_token', layout: 'mobile'
    end
  end
end
