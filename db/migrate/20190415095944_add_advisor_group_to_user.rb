class AddAdvisorGroupToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :advisor_group, :integer, default: 0
  end
end
