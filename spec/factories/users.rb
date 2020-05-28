# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :inet
#  last_sign_in_ip     :inet
#  username            :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  display_name        :string
#  initials            :string(2)
#  email               :string
#  job_title           :string
#  role                :integer          default(4)
#  title               :string(30)
#  appointeeable       :boolean          default(FALSE)
#  advisor_group       :integer          default("not_advisor")
#  gender              :integer          default("male")
#

FactoryBot.define do
  factory :user do
    display_name { "John Wick" }
    username { "johnwick" }
    email { "johnwick@example.com" }
  end

  factory :admin, class: User do
    display_name { "John Wick" }
    username { "johnwick" }
    email { "johnwick@example.com" }
    role { :admin }
  end
end
