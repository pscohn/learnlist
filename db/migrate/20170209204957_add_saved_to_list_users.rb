class AddSavedToListUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :list_users, :saved, :boolean, default: false  
  end
end
