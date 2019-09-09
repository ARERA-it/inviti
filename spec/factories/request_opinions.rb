# == Schema Information
#
# Table name: request_opinions
#
#  id            :bigint           not null, primary key
#  destination   :string           default("")
#  invitation_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :request_opinion do
    destination { "MyString" }
    invitation { nil }
  end
end
