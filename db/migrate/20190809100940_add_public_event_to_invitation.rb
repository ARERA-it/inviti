class AddPublicEventToInvitation < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :public_event, :boolean, default: false
  end
end
