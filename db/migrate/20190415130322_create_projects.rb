class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.integer :president_can_assign, default: 0

      t.timestamps
    end
  end
end
