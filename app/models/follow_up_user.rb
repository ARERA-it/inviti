# == Schema Information
#
# Table name: follow_up_users
#
#  id           :bigint           not null, primary key
#  follow_up_id :bigint
#  user_id      :bigint
#  dismissed    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class FollowUpUser < ApplicationRecord
  belongs_to :follow_up
  belongs_to :user
end
