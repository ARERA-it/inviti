class CreateUserReplies < ActiveRecord::Migration[5.2]
  def change
    create_table :user_replies do |t|
      t.references :appointment_action, foreign_key: true
      t.string :token
      t.integer :status, default: 0
      t.text :comment

      t.timestamps
    end
  end
end
