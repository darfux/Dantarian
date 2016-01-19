class Book < ActiveRecord::Base
  belongs_to :book_info
  validates :book_info, presence: true
  accepts_nested_attributes_for :book_info

  alias_attribute :info, :book_info
  after_initialize :set_default_info
  before_validation :check_info


  def check_info
    info = BookInfo.find_by(isbn: self.info.isbn)
    if info
      self.info = info
    end
  end
  
  def set_default_info
    build_book_info unless self.persisted? || self.book_info
  end

end
