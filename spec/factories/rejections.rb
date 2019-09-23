# == Schema Information
#
# Table name: rejections
#
#  id            :bigint           not null, primary key
#  invitation_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :rejection do
    invitation { nil }
  end
end
