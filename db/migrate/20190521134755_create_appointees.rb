class CreateAppointees < ActiveRecord::Migration[5.2]
  def change
    create_table :appointees do |t|
      t.references :invitation, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :status
      t.timestamps
    end
  end
end
