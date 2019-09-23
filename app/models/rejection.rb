# == Schema Information
#
# Table name: rejections
#
#  id            :bigint           not null, primary key
#  invitation_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Rejection < ApplicationRecord
  paginates_per 10
  belongs_to :invitation
  has_many :rej_users, dependent: :destroy

  def dismissed_by?(user)
    rej_users.find_by(user_id: user.id).dismissed
  end
end
