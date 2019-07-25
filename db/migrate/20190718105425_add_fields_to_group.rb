class AddFieldsToGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :ask_opinion, :boolean, default: false
    add_column :groups, :appointable, :boolean, defalut: false
  end
end
