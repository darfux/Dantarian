class CreateUserTokens < ActiveRecord::Migration
  def change
    create_table :user_tokens do |t|
      t.references :user, index: true, foreign_key: true
      t.string :value
      t.integer :time

      t.timestamps null: false
    end
  end
end
