# == Schema Information
#
# Table name: appointment_steps
#
#  id                    :bigint           not null, primary key
#  appointment_action_id :bigint
#  step                  :integer          default("started")
#  timestamp             :datetime
#  user_reply_id         :bigint
#  comment               :text
#

FactoryBot.define do
  factory :appointment_step do
    appointee { nil }
    curr_user { nil }
    appointed_user { nil }
    step { 1 }
    timestamp { "2019-06-03 23:33:08" }
    user_reply { nil }
    description { "MyString" }
  end
end
