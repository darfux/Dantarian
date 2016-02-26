class BookInfo < ActiveRecord::Base
	validates :isbn, presence: true, uniqueness: true
	validates :name, presence: true

	has_many :books, dependent: :destroy

	def borrowed_users
		books.joins(:user).select(:id, :account, :nickname, :number)
	end
end
