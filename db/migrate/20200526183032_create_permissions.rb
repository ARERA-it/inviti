class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      # t.references :role, foreign_key: true
      t.text :description
      t.string :domain
      t.string :controller
      t.string :action
      # t.boolean :permitted, default: false
      t.integer :position

      t.timestamps
    end
    add_index :permissions, [:controller, :action], name: 'permizzions'
  end
end
