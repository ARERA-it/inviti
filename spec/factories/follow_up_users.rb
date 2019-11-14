# == Schema Information
#
# Table name: follow_up_users
#
#  id           :bigint           not null, primary key
#  follow_up_id :bigint
#  user_id      :bigint
#  dismissed    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :follow_up_user do
    follow_up { nil }
    user { nil }
    dismissed { false }
  end
end
