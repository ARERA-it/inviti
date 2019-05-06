class AddAcceptIdToAssignmentSteps < ActiveRecord::Migration[5.2]
  def change
    add_column :assignment_steps, :accept_id, :integer, index: true
  end
end
