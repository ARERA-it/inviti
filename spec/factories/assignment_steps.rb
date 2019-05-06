# == Schema Information
#
# Table name: assignment_steps
#
#  id               :bigint(8)        not null, primary key
#  invitation_id    :bigint(8)
#  description      :string
#  curr_user_id     :integer
#  assigned_user_id :integer
#  step             :integer
#  timestamp        :datetime
#  accept_id        :integer
#

FactoryBot.define do
  factory :assignment_step do
    invitation { nil }
    description { "MyString" }
    current_user { nil }
    assigned_user { nil }
    step { 1 }
    timestamp { "2019-04-03 11:21:18" }
  end
end
