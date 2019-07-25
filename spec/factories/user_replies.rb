# == Schema Information
#
# Table name: user_replies
#
#  id                    :bigint(8)        not null, primary key
#  appointment_action_id :bigint(8)
#  token                 :string
#  status                :integer          default("not_yet")
#  comment               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

FactoryBot.define do
  factory :user_reply do
    appointment_action { nil }
    token { "MyString" }
    status { 1 }
    comment { "MyText" }
  end
end
