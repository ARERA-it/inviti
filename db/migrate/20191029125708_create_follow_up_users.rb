class CreateFollowUpUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :follow_up_users do |t|
      t.references :follow_up, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :dismissed, default: false

      t.timestamps
    end
  end
end
