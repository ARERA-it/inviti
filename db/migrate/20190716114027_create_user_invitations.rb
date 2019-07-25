class CreateUserInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_invitations do |t|
      t.references :user, foreign_key: true
      t.references :invitation, foreign_key: true

      t.timestamps
    end

     InvitationUser.pluck(:user_id, :invitation_id).uniq.each do |user_id, invitation_id|
       UserInvitation.create(user_id: user_id, invitation_id: invitation_id)
     end
  end
end
