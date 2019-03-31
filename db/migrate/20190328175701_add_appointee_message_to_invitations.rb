class AddAppointeeMessageToInvitations < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :appointee_message, :string
  end
end
