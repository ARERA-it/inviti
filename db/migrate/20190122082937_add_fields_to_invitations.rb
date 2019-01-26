class AddFieldsToInvitations < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :decision, :integer, default: 0

  end
end
