# == Schema Information
#
# Table name: accepts
#
#  id            :bigint(8)        not null, primary key
#  token         :string
#  invitation_id :bigint(8)
#  user_id       :bigint(8)
#  decision      :integer          default("not_yet")
#  comment       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :accept do
    token { "MyString" }
    invitation { nil }
    user { nil }
    decision { 1 }
    comment { "MyText" }
  end
end
