# == Schema Information
#
# Table name: opinions
#
#  id            :bigint           not null, primary key
#  user_id       :bigint
#  invitation_id :bigint
#  selection     :integer          default("undefined")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :opinion do
    
  end
end
