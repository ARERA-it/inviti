# == Schema Information
#
# Table name: request_opinions
#
#  id            :bigint           not null, primary key
#  invitation_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#

class RequestOpinion < ApplicationRecord
  # user is the person who requested an opinion
  belongs_to :invitation
  belongs_to :user
  has_many :request_opinion_groups, dependent: :destroy
  has_many :groups, through: :request_opinion_groups

  after_create :send_requests

  def groups_users
    groups.map{|g| g.users}.flatten.uniq
  end

  def send_requests
    OpinionMailer.send_request_opinion(id)
  end
end
