# == Schema Information
#
# Table name: groups
#
#  id          :bigint           not null, primary key
#  name        :string(40)
#  in_use      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ask_opinion :boolean          default(FALSE)
#  appointable :boolean
#

FactoryBot.define do
  factory :group do
    name { "MyString" }
    in_use { true }
    ask_opinion { true }
    appointable { true }
  end
end
