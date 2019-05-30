class GroupsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :groups_users, id: false do |t|
      t.integer :group_id, index: true
      t.integer :user_id, index: true
    end

  end
end
