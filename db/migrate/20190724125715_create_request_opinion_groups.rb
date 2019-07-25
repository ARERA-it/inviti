class CreateRequestOpinionGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :request_opinion_groups do |t|
      t.references :request_opinion, foreign_key: true
      t.references :group, foreign_key: true

      # t.timestamps
    end

    # remove_column :request_opinions, :destination
  end
end
