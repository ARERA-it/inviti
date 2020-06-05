# == Schema Information
#
# Table name: request_opinions
#
#  id            :bigint           not null, primary key
#  invitation_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#

FactoryBot.define do
  factory :request_opinion do
    destination { "MyString" }
    invitation { nil }
  end
end
