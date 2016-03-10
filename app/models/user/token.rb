class User::Token < ActiveRecord::Base
  TOKEN_LENGTH = 6
  EXPIRE_DURATION = 60
  belongs_to :user
  validates :user, presence: true, uniqueness: true



  def self.generate(user, path)
    self.where(user: user).destroy_all
    self.new(user: user, 
      value: SecureRandom.hex(TOKEN_LENGTH/2).upcase, time: Time.now.to_i, target_path:path)
  end

  def self.parse(token_str)
    return nil unless match = token_str.match("(\\d+)\\-([A-Za-z0-9]{#{TOKEN_LENGTH}})")
    uid, value = match[1], match[2]
    saved_token = find_by(user_id: uid)
    return nil unless saved_token && saved_token.value == value && Time.now.to_i-saved_token.time<EXPIRE_DURATION
    saved_token
  end

  def to_s
  	"#{user_id}-#{value}"
  end

end
