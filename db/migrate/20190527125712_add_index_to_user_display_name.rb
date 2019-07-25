class AddIndexToUserDisplayName < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :display_name
  end
end
