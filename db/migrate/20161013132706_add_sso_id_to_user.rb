class AddSsoIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :sso_id, :integer, index: true
    add_index :users, :sso_id, unique: true
  end
end
