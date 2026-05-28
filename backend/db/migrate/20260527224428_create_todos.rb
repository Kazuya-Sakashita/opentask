class CreateTodos < ActiveRecord::Migration[8.1]
  def change
    create_table :todos do |t|
      t.string :public_id, null: false

      t.references :user, null: false, foreign_key: true

      t.string :title, null: false
      t.text :description

      t.boolean :completed, null: false, default: false

      t.datetime :deleted_at

      t.timestamps
    end

    add_index :todos, :public_id, unique: true
    add_index :todos, :deleted_at
  end
end
