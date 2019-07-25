# == Schema Information
#
# Table name: user_interactions
#
#  id              :bigint(8)        not null, primary key
#  user_id         :bigint(8)
#  controller_name :string(31)
#  action_name     :string(31)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :user_interaction do
    user { nil }
    controller_name { "MyString" }
    action_name { "MyString" }
  end
end
