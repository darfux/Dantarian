class AddSourceToBookInfo < ActiveRecord::Migration
  def change
  	add_column :book_infos, :source, :string
  end
end
