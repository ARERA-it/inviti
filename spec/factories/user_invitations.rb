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

FactoryBot.define do
  factory :user_invitation do
    user { nil }
    invitation { nil }
  end
end
