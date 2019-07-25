# == Schema Information
#
# Table name: request_opinions
#
#  id            :bigint(8)        not null, primary key
#  destination   :string           default("")
#  invitation_id :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :request_opinion do
    destination { "MyString" }
    invitation { nil }
  end
end
