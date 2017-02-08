class CreateListUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :list_users do |t|
      t.belongs_to :user, index: true
      t.belongs_to :list, index: true
      t.string :state, default: 'todo', null: false

      t.timestamps
    end
  end
end
