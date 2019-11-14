class CreateFollowUpActions < ActiveRecord::Migration[5.2]
  def change
    create_table :follow_up_actions do |t|
      t.references :follow_up, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :fu_action, default: 0
      t.text :comment

      t.timestamps
    end
  end
end
