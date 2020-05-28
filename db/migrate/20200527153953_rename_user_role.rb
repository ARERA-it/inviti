class RenameUserRole < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :role, :role_id
    add_index :users, :role_id
  end
end
