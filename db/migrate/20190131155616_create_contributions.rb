class CreateContributions < ActiveRecord::Migration[5.2]
  def change
    create_table :contributions do |t|
      t.belongs_to :invitation, index: true
      t.belongs_to :user, index: true
      t.string :title
      t.text :note
      t.timestamps
    end
  end
end
