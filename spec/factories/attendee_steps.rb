# == Schema Information
#
# Table name: attendee_steps
#
#  id            :bigint(8)        not null, primary key
#  invitation_id :bigint(8)
#  description   :string
#  user_id       :bigint(8)
#  step          :integer
#  timestamp     :datetime
#

FactoryBot.define do
  factory :attendee_step do
    invitation { nil }
    description { "MyString" }
    attendee { nil }
    step { 1 }
    dtime { "2019-04-01 11:57:06" }
  end
end
