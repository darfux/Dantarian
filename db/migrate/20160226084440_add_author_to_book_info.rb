class AddAuthorToBookInfo < ActiveRecord::Migration
  def change
  	add_column :book_infos, :author, :string
  end
end
