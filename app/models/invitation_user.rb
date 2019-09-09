# == Schema Information
#
# Table name: invitations_users
#
#  invitation_id :bigint
#  user_id       :bigint
#

# TODO: obsolete
class InvitationUser < ApplicationRecord
  self.table_name = "invitations_users"

end
