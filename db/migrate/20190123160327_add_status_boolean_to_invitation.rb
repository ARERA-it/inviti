class AddStatusBooleanToInvitation < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :need_info, :boolean, default: true, index: true
    add_column :invitations, :opinion_expressed, :boolean, default: false, index: true
    add_column :invitations, :expired, :boolean, default: false, index: true
  end
end
