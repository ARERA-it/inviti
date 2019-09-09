# == Schema Information
#
# Table name: comments
#
#  id            :bigint           not null, primary key
#  user_id       :bigint
#  invitation_id :bigint
#  content       :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :comment do
    
  end
end
