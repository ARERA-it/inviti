# == Schema Information
#
# Table name: follow_ups
#
#  id            :bigint           not null, primary key
#  invitation_id :bigint
#  status        :integer          default("rejected")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :follow_up do
    invitation { nil }
    status { 1 }
  end
end
