class AddDescriptionToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :description, :text
    add_index :users, :username, unique: true
  end
end
