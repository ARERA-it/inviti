# == Schema Information
#
# Table name: appointment_actions
#
#  id           :bigint           not null, primary key
#  appointee_id :bigint
#  group_id     :bigint
#  user_id      :bigint
#  kind         :integer
#  comment      :text
#  timestamp    :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :appointment_action do
    appointee { nil }
    group { nil }
    user { nil }
    kind { 1 }
    comment { "MyText" }
    timestamp { "2019-06-13 11:10:51" }
  end
end
