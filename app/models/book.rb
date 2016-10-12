class Book < ActiveRecord::Base
  scope :with_info, ->{ 
    book_info_column = ['isbn', 'name', 'cover', 'author'].
      map{  |attr| "book_infos."+attr.to_s }.join(', ')
    joins(:book_info).select("books.*, #{book_info_column}") 
  }

  belongs_to :book_info
  belongs_to :user, optional: true
  belongs_to :recorder, class_name: :User, foreign_key: :recorder_id
  validates :book_info, presence: true
  accepts_nested_attributes_for :book_info

  alias_attribute :info, :book_info
  alias_attribute :borrower, :user
  after_initialize :set_default_info
  before_validation :check_info
  before_save :set_number
  before_save :trim_isbn


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

  def trim_isbn
    self.book_info.isbn.gsub!(/[- ]/, '') unless self.persisted?
  end

end
