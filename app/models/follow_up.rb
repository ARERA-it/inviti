# == Schema Information
#
# Table name: follow_ups
#
#  id            :bigint           not null, primary key
#  invitation_id :bigint
#  status        :integer          default("rejected")
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

  def FollowUp.search_for(user:, page: )
    r1 = FollowUp.pluck(:id)
    r2 = FollowUpUser.where(user: user).pluck(:follow_up_id)
    (r1-r2).each do |r_id|
      FollowUpUser.create(follow_up_id: r_id, user: user)
    end
    FollowUp.joins(:invitation, :follow_up_users).where('follow_up_users.user_id' => user.id).order('follow_up_users.dismissed', 'follow_ups.created_at DESC').page page
  end
end
