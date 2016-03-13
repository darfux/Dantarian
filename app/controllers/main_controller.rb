class MainController < ApplicationController
  include Tubesock::Hijack
  def index
  end

  def chat
    token = params['token']
    hijack do |tubesock|
      tubesock.onclose do |data|
        # byebug
      end

      Thread.new do
        time_begin = Time.now.to_i
        logged = nil
        loop do
          break if logged = Rails.cache.read({token: token})
          sleep 0.5
          now = Time.now.to_i
          break if now - time_begin > User::Token::EXPIRE_DURATION
        end
        unless logged
          tubesock.send_data "fail"
        else
          tubesock.send_data "success"
        end
        Rails.cache.delete_entry({token: token})
        tubesock.close
      end

    end
  end
end
