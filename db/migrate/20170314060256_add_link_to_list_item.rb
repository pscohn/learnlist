class AddLinkToListItem < ActiveRecord::Migration[5.0]
  def change
    add_column :list_items, :link, :string
  end
end
