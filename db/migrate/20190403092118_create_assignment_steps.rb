class CreateAssignmentSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :assignment_steps do |t|
      t.references :invitation, foreign_key: true
      t.string :description
      t.integer :curr_user_id, index: true
      t.integer :assigned_user_id, index: true
      t.integer :step
      t.datetime :timestamp
    end
  end
end
