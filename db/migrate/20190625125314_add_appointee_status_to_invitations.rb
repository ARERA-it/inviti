class AddAppointeeStatusToInvitations < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :appointee_status, :integer, default: 0, index: true
    add_column :invitations, :appointee_steps_count, :integer, default: 0, index: true
  end
end
