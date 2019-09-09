# == Schema Information
#
# Table name: request_opinions
#
#  id            :bigint           not null, primary key
#  destination   :string           default("")
#  invitation_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class RequestOpinion < ApplicationRecord
  # attr_accessor :group
  belongs_to :invitation
  has_many :request_opinion_groups, dependent: :destroy
  has_many :groups, through: :request_opinion_groups

  # before_save :prepare_destination
  after_create :send_requests


  # def prepare_destination
  #   self.destination = group.join(",") if group
  # end

  # def groups
  #   Group.where(id: destination.split(','))
  # end

  def groups_users
    groups.map{|g| g.users}.flatten.uniq
    # Group.where(id: destination.split(',')).map{|g| g.users}.flatten.uniq
  end


  def send_requests
    OpinionMailer.send_request_opinion(id)
  end
end
