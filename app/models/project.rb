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

class Project < ApplicationRecord
  # has_settings do |s|
  #   s.key :dashboard, :defaults => { :theme => 'blue', :view => 'monthly', :filter => false }
  #   s.key :calendar,  :defaults => { :scope => 'company'}
  # end
  enum president_can_assign: [:always, :at_least_one_opinion, :all_opinions]

  def Project.primo
    Project.first || Project.create
  end


  def refresh_tokens
    df = DeviceFlow.new(ENV["AZURE_TENANT_ID"], ENV["AZURE_CLIENT_ID"])
    res = df.refresh_tokens(refresh_token: email_refresh_token)
    if res['access_token']
      update(email_access_token: df.access_token, email_refresh_token: df.refresh_token)
      true
    else
      false
    end
  end
end
