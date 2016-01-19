class BookInfo < ActiveRecord::Base
	validates :isbn, presence: true, uniqueness: true
	validates :name, presence: true

	has_many :books
end
