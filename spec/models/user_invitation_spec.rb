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

require 'rails_helper'

RSpec.describe UserInvitation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
