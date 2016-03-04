class BookInfo < ActiveRecord::Base
  validates :isbn, presence: true, uniqueness: true
  validates :name, presence: true

  has_many :books, dependent: :destroy
  has_and_belongs_to_many :users, join_table: :user_favor_books
  before_destroy { users.clear }

  def borrowed_users
    books.joins(:user).select(:id, :account, :nickname, :number)
  end
end
