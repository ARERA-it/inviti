class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      t.references :role, foreign_key: true
      t.text :description
      t.string :controller
      t.string :action
      t.boolean :permitted, default: false

      t.timestamps
    end
    add_index :permissions, [:role_id, :controller, :action], name: 'permizzions'
  end
end
