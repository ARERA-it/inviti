# == Schema Information
#
# Table name: user_invitations
#
#  id            :bigint           not null, primary key
#  user_id       :bigint
#  invitation_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe UserInvitation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
