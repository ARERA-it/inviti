class AddStateToInvitations < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :state, :integer, default: 0, index: true
  end
end
