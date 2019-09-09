# == Schema Information
#
# Table name: user_interactions
#
#  id              :bigint           not null, primary key
#  user_id         :bigint
#  controller_name :string(31)
#  action_name     :string(31)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class UserInteraction < ApplicationRecord
  belongs_to :user
  default_scope { includes(:user).order(created_at: :desc) }
end
