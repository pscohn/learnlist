class AddSlugToUser < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :description, :string
    add_column :lists, :body, :text
  end
end
