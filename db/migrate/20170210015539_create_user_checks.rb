class CreateUserChecks < ActiveRecord::Migration[5.0]
  def change
    create_table :user_checks do |t|
      t.references :user, foreign_key: true, null: false
      t.references :list_item, foreign_key: true, null: false
      t.boolean :completed, default: false, null: false

      t.timestamps
    end
  end
end
