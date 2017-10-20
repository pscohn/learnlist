class AddPrivateToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :private, :boolean, default: false
  end
end
