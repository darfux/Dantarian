class User < ActiveRecord::Base
  has_secure_password
  has_many :books

  has_and_belongs_to_many :book_infos, through: :user_favor_books
  before_destroy { book_infos.clear }

  def borrowed_books
    books.joins(:book_info).select("book_infos.*", "books.*")
  end
end
