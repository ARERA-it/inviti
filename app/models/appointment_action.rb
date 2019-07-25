# == Schema Information
#
# Table name: appointment_actions
#
#  id           :bigint(8)        not null, primary key
#  appointee_id :bigint(8)
#  group_id     :bigint(8)
#  user_id      :bigint(8)
#  kind         :integer
#  comment      :text
#  timestamp    :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class AppointmentAction < ApplicationRecord
  # attr_accessor :ur_status, :ur_comment, :step # togli
  attr_accessor :manual_user_reply_creation, :manual_step_creation
  belongs_to :appointee
  belongs_to :group, optional: true
  belongs_to :user # the person that appoints
  enum kind: [:proposal, :appoint, :direct_appoint, :canceled]

  # audited associated_with: :invitation, only: :id


  has_many :steps, class_name: "AppointmentStep", foreign_key: "appointment_action_id", dependent: :destroy
  has_one  :user_reply, class_name: "UserReply", dependent: :destroy

  before_create :set_timestamp
  after_create :create_user_reply_and_step

  def create_user_reply_and_step
    ur = nil
    if manual_user_reply_creation!=true
      ur = create_user_reply
    end
    if manual_step_creation!=true
      steps.create(user_reply: ur ||= user_reply)
    end
  end

  def comment?
    !comment.blank?
  end

  private

    def set_timestamp
      self.timestamp = Time.now
    end
end
