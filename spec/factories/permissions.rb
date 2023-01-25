# == Schema Information
#
# Table name: permissions
#
#  id          :bigint           not null, primary key
#  description :text
#  domain      :string
#  controller  :string
#  action      :string
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  code        :string
#

FactoryBot.define do
  factory :permission do
    role { nil }
    controller { "MyString" }
    action { "MyString" }
    permitted { false }
  end
end
