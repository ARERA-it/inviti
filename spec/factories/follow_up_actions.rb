# == Schema Information
#
# Table name: follow_up_actions
#
#  id           :bigint           not null, primary key
#  follow_up_id :bigint
#  user_id      :bigint
#  fu_action    :integer          default("none_")
#  comment      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :follow_up_action do
    follow_up { nil }
    user { nil }
    fu_action { 1 }
    comment { "MyText" }
  end
end
