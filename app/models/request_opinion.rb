# == Schema Information
#
# Table name: request_opinions
#
#  id            :bigint(8)        not null, primary key
#  destination   :string
#  invitation_id :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class RequestOpinion < ApplicationRecord
  attr_accessor :dest
  belongs_to :invitation

  before_save :prepare_destination
  after_save :send_requests


  def prepare_destination
    self.destination = dest.join(",") if @dest
  end


  def send_requests
    OpinionMailer.with(req_opinion: id).request_opinion.deliver_later
  end
end
