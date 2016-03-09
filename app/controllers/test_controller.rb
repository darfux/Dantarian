class TestController < ApplicationController
  skip_before_action :authenticate_user!
  unless Rails.env.development?
    before_action :forbid
  end

  def index
  end
  
  private
    def forbid
      render :status => :forbidden, :text => "403 Forbidden"
    end
end
