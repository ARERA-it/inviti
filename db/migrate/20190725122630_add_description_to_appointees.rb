class AddDescriptionToAppointees < ActiveRecord::Migration[5.2]
  def change
    add_column :appointees, :description, :string, default: nil
  end
end
