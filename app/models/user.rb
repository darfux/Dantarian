class User < ActiveRecord::Base
  # has_secure_password
  has_many :books
  has_many :record_books, class_name: :Book, foreign_key: :recorder_id
  
  has_and_belongs_to_many :book_infos, join_table: :user_favor_books
  before_destroy { book_infos.clear }


  def borrowed_books
    books.joins(:book_info).select("book_infos.*", "books.*")
  end

  def related_books
  	connection = ActiveRecord::Base.connection
  	sql = %Q{
		SELECT 
		book_infos.name, book_infos.isbn, book_infos.cover, book_infos.author, book_infos.source,
		COALESCE(borrowed_books.id, -1) as borrowed_id,
    COALESCE(borrowed_books.updated_at, user_favor_books.created_at) as relate_time,
		user_favor_books.id as favored
		FROM "users"
		LEFT OUTER JOIN book_infos ON book_infos.id = "user_favor_books"."book_info_id" 
		LEFT OUTER JOIN "user_favor_books" ON "users"."id" = "user_favor_books"."user_id" 

		LEFT OUTER JOIN books as borrowed_books ON  borrowed_books.user_id = users.id and  borrowed_books.book_info_id = book_infos.id
  		WHERE users.id = #{self.id} AND (borrowed_books.id IS NOT NULL OR favored IS NOT NULL)
    ORDER BY relate_time DESC
  	}
  	connection.execute(sql)
  end

  def recent_record_books(top = 10)
    record_books.with_info.order('created_at desc').limit(top)
  end
end
