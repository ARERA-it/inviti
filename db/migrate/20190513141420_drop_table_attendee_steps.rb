class DropTableAttendeeSteps < ActiveRecord::Migration[5.2]
  def change
    drop_table :attendee_steps
  end
end
