# == Schema Information
#
# Table name: projects
#
#  id                   :bigint(8)        not null, primary key
#  president_can_assign :integer          default("always")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryBot.define do
  factory :project do
    
  end
end
