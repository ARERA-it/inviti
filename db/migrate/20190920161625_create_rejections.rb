class CreateRejections < ActiveRecord::Migration[5.2]
  def change
    create_table :rejections do |t|
      t.references :invitation, foreign_key: true

      t.timestamps
    end
  end
end
