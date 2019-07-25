# == Schema Information
#
# Table name: invitations_users
#
#  invitation_id :bigint(8)
#  user_id       :bigint(8)
#

# TODO: obsolete
class InvitationUser < ApplicationRecord
  self.table_name = "invitations_users"

end
