class UserFavorBook < ActiveRecord::Base
  belongs_to :user
  belongs_to :book_info
  validates_uniqueness_of :user_id, :scope => [:book_info_id]
end
