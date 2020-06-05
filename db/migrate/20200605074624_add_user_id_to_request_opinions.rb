class AddUserIdToRequestOpinions < ActiveRecord::Migration[5.2]
  def change
    add_column :request_opinions, :user_id, :integer, default: nil
    remove_column :request_opinions, :destination, :string
  end
end
