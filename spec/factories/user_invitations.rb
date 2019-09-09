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

FactoryBot.define do
  factory :user_invitation do
    user { nil }
    invitation { nil }
  end
end
