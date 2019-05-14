class CreateUserInteractions < ActiveRecord::Migration[5.2]
  def change
    create_table :user_interactions do |t|
      t.references :user, foreign_key: true
      t.string :controller_name, limit: 31
      t.string :action_name, limit: 31

      t.timestamps
    end
  end
end
