# == Schema Information
#
# Table name: appointees
#
#  id            :bigint           not null, primary key
#  invitation_id :bigint
#  user_id       :bigint
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
