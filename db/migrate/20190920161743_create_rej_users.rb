class CreateRejUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :rej_users do |t|
      t.references :rejection, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :dismissed, default: false

      t.timestamps
    end
  end
end
