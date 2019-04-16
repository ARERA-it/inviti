# == Schema Information
#
# Table name: projects
#
#  id                   :bigint(8)        not null, primary key
#  president_can_assign :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Project < ApplicationRecord
  # has_settings do |s|
  #   s.key :dashboard, :defaults => { :theme => 'blue', :view => 'monthly', :filter => false }
  #   s.key :calendar,  :defaults => { :scope => 'company'}
  # end
  enum president_can_assign: [:always, :at_least_one_opinion, :all_opinions]

  def Project.primo
    Project.first || Project.create
  end
end
