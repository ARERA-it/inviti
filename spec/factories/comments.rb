# == Schema Information
#
# Table name: comments
#
#  id            :bigint(8)        not null, primary key
#  user_id       :bigint(8)
#  invitation_id :bigint(8)
#  content       :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :comment do
    
  end
end
