class AddSsOidToUser < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :sso_id, :integer, index: true
  end
end
