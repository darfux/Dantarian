class AddRecorderToBook < ActiveRecord::Migration
  def change
    change_table :books do |t|
      t.references :recorder, index: true 
    end
  end
end
