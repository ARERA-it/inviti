class CreateAppointmentActions < ActiveRecord::Migration[5.2]
  def change
    create_table :appointment_actions do |t|
      t.references :appointee, foreign_key: true
      t.references :group, foreign_key: true, default: nil
      t.references :user, foreign_key: true
      t.integer :kind
      t.text :comment
      t.datetime :timestamp

      t.timestamps
    end
  end
end
