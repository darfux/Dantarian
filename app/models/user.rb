class User < ActiveRecord::Base
  has_secure_password
  has_many :books

  def borrowed_books
    books.joins(:book_info).select("book_infos.*", "books.*")
  end
end
