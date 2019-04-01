class AddSomeFieldsToInvitations < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :email_decoded, :text
    add_column :invitations, :email_text_part, :text
    add_column :invitations, :email_html_part, :text
  end
end
