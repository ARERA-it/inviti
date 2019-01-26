class CreateInvitationsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations_users, id: false  do |t|
      t.belongs_to :invitation, index: true
      t.belongs_to :user, index: true
    end
  end
end
