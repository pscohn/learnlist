class AddSavesToLists < ActiveRecord::Migration[5.0]
  def up
    add_column :lists, :saves, :integer, index: true, default: 0, null: false
    List.all.each do |list|
      list.update_attributes(saves: list.list_users.where(saved: true).count)
    end
  end

  def down
    remove_column :lists, :saves
  end
end
