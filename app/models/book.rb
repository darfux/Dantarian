class Book < ActiveRecord::Base
  belongs_to :book_info
  belongs_to :user
  validates :book_info, presence: true
  accepts_nested_attributes_for :book_info

  alias_attribute :info, :book_info
  alias_attribute :borrower, :user
  after_initialize :set_default_info
  before_validation :check_info
  before_save :set_number


  def check_info
    info = BookInfo.find_by(isbn: self.info.isbn)
    if info
      self.info = info
    end
  end
  
  def set_default_info
    build_book_info unless self.persisted? || self.book_info
  end

  def set_number
    self.number = self.book_info.books.size+1
  end

end
