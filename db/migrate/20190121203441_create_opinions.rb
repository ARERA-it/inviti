class CreateOpinions < ActiveRecord::Migration[5.2]
  def change
    create_table :opinions do |t|
      t.references :user, foreign_key: true
      t.references :invitation, foreign_key: true
      t.integer :selection, default: 0
      t.timestamps
    end
  end
end
