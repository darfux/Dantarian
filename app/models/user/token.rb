class User::Token < ActiveRecord::Base
  TOKEN_LENGTH = 6
  belongs_to :user
  validates :user, presence: true, uniqueness: true



  def self.generate(user)
    self.where(user: user).destroy_all
    self.new(user: user, 
      value: SecureRandom.hex(TOKEN_LENGTH/2).upcase, time: Time.now.to_i)
  end

  def to_s
  	"#{user_id}-#{value}"
  end

end
