class CreateFollowUps < ActiveRecord::Migration[5.2]
  def change
    create_table :follow_ups do |t|
      t.references :invitation, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
