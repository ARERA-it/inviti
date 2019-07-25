# == Schema Information
#
# Table name: appointees
#
#  id            :bigint(8)        not null, primary key
#  invitation_id :bigint(8)
#  user_id       :bigint(8)
#  status        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  description   :string
#

FactoryBot.define do
  factory :appointee do
    invitation { nil }
    user { nil }
    status { 1 }
  end
end
