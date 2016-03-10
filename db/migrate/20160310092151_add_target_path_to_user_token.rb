class AddTargetPathToUserToken < ActiveRecord::Migration
  def change
  	add_column :user_tokens, :target_path, :string
  end
end
