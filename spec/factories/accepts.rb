# == Schema Information
#
# Table name: accepts
#
#  id            :bigint           not null, primary key
#  token         :string
#  invitation_id :bigint
#  user_id       :bigint
#  decision      :integer          default("not_yet")
#  comment       :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  proposal      :boolean          default(FALSE)
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
