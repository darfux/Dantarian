class ChangeBookToBookInfos < ActiveRecord::Migration
  def change
    create_table :book_infos do |t|
      t.string :isbn
      t.string :name
      t.string :cover

      t.timestamps null: false
    end
    drop_table :books
    create_table :books do |t|
    	t.references :book_info, index: true
    	t.references :user, index: true
    	t.integer :number

      	t.timestamps null: false
	end
  end
end
