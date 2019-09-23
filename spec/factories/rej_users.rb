# == Schema Information
#
# Table name: rej_users
#
#  id           :bigint           not null, primary key
#  rejection_id :bigint
#  user_id      :bigint
#  dismissed    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :rej_user do
    rejection { nil }
    user { nil }
    dismissed { false }
  end
end
