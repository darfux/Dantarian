class CreateUserFavorBooks < ActiveRecord::Migration
  def change
    create_table :user_favor_books do |t|
      t.references :user, index: true, foreign_key: true
      t.references :book_info, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
