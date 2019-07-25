class CreateAppointmentSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :appointment_steps do |t|
      t.references :appointment_action, foreign_key: true
      t.integer :step, default: 0
      t.datetime :timestamp
      t.references :user_reply, foreign_key: true
      t.text :comment
    end
  end
end
