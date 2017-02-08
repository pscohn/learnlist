class CreateLists < ActiveRecord::Migration[5.0]
  def change
    create_table :lists do |t|
      t.string :name
      t.text :description
      t.string :category
      t.string :state, default: 'draft', null: false
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
