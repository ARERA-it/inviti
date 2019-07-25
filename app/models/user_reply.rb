# == Schema Information
#
# Table name: user_replies
#
#  id                    :bigint(8)        not null, primary key
#  appointment_action_id :bigint(8)
#  token                 :string
#  status                :integer          default("not_yet")
#  comment               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class UserReply < ApplicationRecord
  attr_accessor :disable_email, :step_timestamp
  belongs_to :appointment_action, optional: true
  enum status: [:not_yet, :accepted, :rejected]
  before_create :add_token
  after_create :send_email
  after_update :append_step

  private

  def append_step
    if accepted? or rejected?
      appointment_action.steps.create(user_reply: self, step: status, comment: comment, timestamp: step_timestamp || Time.now) # [:started, :accepted, :rejected, :expired]
    end
  end

  def send_email
    if disable_email!=true
      aa = appointment_action
      case
      when aa.proposal?
        AppointeeMailer.with(user_reply_id: id).proposal.deliver_later(wait: 5.seconds)
      when aa.appoint?
        AppointeeMailer.with(user_reply_id: id).appointment.deliver_later(wait: 5.seconds)
      when aa.direct_appoint?
        AppointeeMailer.with(user_reply_id: id).direct_appointment.deliver_later(wait: 5.seconds)
      when aa.canceled?
        AppointeeMailer.with(user_reply_id: id).canceled.deliver_later(wait: 5.seconds)
      end
    end
  end

  def add_token
    self.token = generate_unique_token
  end

  def generate_unique_token
    token = SecureRandom.hex
    if Accept.find_by(token: token)
      generate_unique_token
    else
      token
    end
  end

end
