class AddFieldsToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :email_access_token, :text
    add_column :projects, :email_refresh_token, :text
    add_column :projects, :access_token_expires, :datetime
  end
end
