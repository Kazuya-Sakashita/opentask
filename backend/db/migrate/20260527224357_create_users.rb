class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :public_id, null: false
      t.string :supabase_user_id, null: false
      t.string :email, null: false
      t.string :name, null: false
      t.integer :role, null: false, default: 0

      t.timestamps
    end

    add_index :users, :public_id, unique: true
    add_index :users, :supabase_user_id, unique: true
  end
end
