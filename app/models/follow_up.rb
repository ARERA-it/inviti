# == Schema Information
#
# Table name: follow_ups
#
#  id            :bigint           not null, primary key
#  invitation_id :bigint
#  status        :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class FollowUp < ApplicationRecord
  belongs_to :invitation
  paginates_per 10
  has_many :follow_up_users, dependent: :destroy
  has_many :follow_up_actions, dependent: :destroy

  def dismissed_by?(user)
    follow_up_users.find_by(user_id: user.id).dismissed
  end

  enum status: [:rejected]

end
