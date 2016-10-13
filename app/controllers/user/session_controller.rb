class User::SessionController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :create_by_token]
  def new
    sso_login
    # @session = User::Session.new
  end

  # def create
  #   session_params = params[:user_session]
  #   @user = User.find_by(account: session_params[:account])
  #   if @user && @user.authenticate(session_params[:password])
  #     session[:user_id] = @user.id
  #     redirect_to root_path
  #   else
  #   end
  # end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
    # redirect_to sso_logout_url
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

  protected

    def sso_logout_url
      # URI::HTTP.build(
    end

    def sso_login
      timestamp = Time.now.to_i.to_s
      token = gen_sso_token(current_host + timestamp + Settings.sso_token)
      sso_request = URI::HTTP.build(host: Settings.sso_host, port: (Settings.sso_port||80), path: "/users/sign_in",
        query: {
          from: current_server,
          timestamp: timestamp,
          token: token
        }.to_query
      )
      redirect_to sso_request.to_s
  end
end
