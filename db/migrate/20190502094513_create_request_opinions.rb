class CreateRequestOpinions < ActiveRecord::Migration[5.2]
  def change
    create_table :request_opinions do |t|
      t.string :destination, default: ""
      t.references :invitation, foreign_key: true

      t.timestamps
    end
  end
end
