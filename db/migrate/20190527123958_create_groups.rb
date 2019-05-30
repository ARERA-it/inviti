class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name, limit: 40, index: true
      t.boolean :in_use, default: true

      t.timestamps
    end
  end
end
