class Drop2InvitationColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :invitations, :email_text_part
    remove_column :invitations, :email_html_part
    remove_column :invitations, :alt_appointee_name
  end
end
