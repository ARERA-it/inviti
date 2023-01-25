# == Schema Information
#
# Table name: projects
#
#  id                   :bigint           not null, primary key
#  president_can_assign :integer          default("always")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  email_access_token   :text
#  email_refresh_token  :text
#  access_token_expires :datetime
#

FactoryBot.define do
  factory :project do
    
  end
end
