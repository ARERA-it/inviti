class AddOrgCategoryToInvitations < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :org_category, :integer, default: 0
  end
end
