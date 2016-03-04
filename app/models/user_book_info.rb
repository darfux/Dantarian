class UserBookInfo < ActiveRecord::Base
  belongs_to :user
  belongs_to :book_info
end
