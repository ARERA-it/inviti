# == Schema Information
#
# Table name: permissions
#
#  id          :bigint           not null, primary key
#  role_id     :bigint
#  description :text
#  controller  :string
#  action      :string
#  permitted   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :permission do
    role { nil }
    controller { "MyString" }
    action { "MyString" }
    permitted { false }
  end
end
