class CreateAttendeeSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :attendee_steps do |t|
      t.references :invitation, foreign_key: true
      t.string :description
      t.references :user, foreign_key: true
      t.integer :step
      t.datetime :timestamp
    end
  end
end
