# == Schema Information
#
# Table name: user_invitations
#
#  id            :bigint(8)        not null, primary key
#  user_id       :bigint(8)
#  invitation_id :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class UserInvitation < ApplicationRecord
  belongs_to :user
  belongs_to :invitation

  def seen_at
    updated_at
  end

  # Return previous seen_at (before being touched)
  def UserInvitation.create_or_touch(user, invitation)
    ui = UserInvitation.find_by(user: user, invitation: invitation)
    if ui
      seen_at = ui.seen_at
      ui.touch
    else
      # seen_at
      ui = UserInvitation.create(user: user, invitation: invitation)
      seen_at = ui.seen_at
    end
    seen_at
  end
end
