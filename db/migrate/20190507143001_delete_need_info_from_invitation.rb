class DeleteNeedInfoFromInvitation < ActiveRecord::Migration[5.2]
  def change
    remove_column :invitations, :need_info
    remove_column :invitations, :opinion_expressed
    remove_column :invitations, :expired
  end
end
