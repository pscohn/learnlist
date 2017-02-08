class CreateListItems < ActiveRecord::Migration[5.0]
  def change
    create_table :list_items do |t|
      t.string :title
      t.text :description
      t.integer :index
      t.belongs_to :list, index: true

      t.timestamps
    end
  end
end
