class CreateAccepts < ActiveRecord::Migration[5.2]
  def change
    create_table :accepts do |t|
      t.string :token, index: true
      t.references :invitation, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :decision, default: 0
      t.text :comment

      t.timestamps
    end
  end
end
