class AddProposalToAccepts < ActiveRecord::Migration[5.2]
  def change
    add_column :accepts, :proposal, :boolean, default: false
  end
end
