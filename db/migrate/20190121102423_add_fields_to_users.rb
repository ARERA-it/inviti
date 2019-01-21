class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :display_name, :string
    add_column :users, :initials, :string, limit: 2
    add_column :users, :email, :string
    add_column :users, :job_title, :string
    add_column :users, :role, :integer, default: 4
    add_column :users, :title, :string, limit: 30
    add_column :users, :appointeeable, :boolean, default: false

    add_index :users, :email, unique: true
  end


end
