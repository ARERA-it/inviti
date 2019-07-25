# == Schema Information
#
# Table name: appointment_steps
#
#  id                    :bigint(8)        not null, primary key
#  appointment_action_id :bigint(8)
#  step                  :integer          default("started")
#  timestamp             :datetime
#  user_reply_id         :bigint(8)
#  comment               :text
#

class AppointmentStep < ApplicationRecord
  belongs_to :action, class_name: "AppointmentAction", foreign_key: "appointment_action_id"
  belongs_to :user_reply, optional: true

  audited associated_with: :action, only: :step

  enum step: [:started, :accepted, :rejected, :expired]
  default_scope -> { order('timestamp ASC') }

  before_create :set_timestamp #, :generate_description
  after_save :update_appointee
  # before_save :append_audit_comment
  # def append_audit_comment
  #   if new_record? # because before_update doesn't work
  #     self.audit_comment = "#{user.name} ha aggiunto un commento"
  #   else
  #     # do nothing
  #   end
  # end


  def description
    descriptions(action.kind, step, action.user, appointee: action.appointee.user)
  end

  def comment?
    !comment.blank?
  end

  def update_appointee
    action.appointee.update_status(kind: action.kind, step: step, description: description)
  end


  private

    def set_timestamp
      self.timestamp = Time.now if timestamp.nil?
    end

    def descriptions(kind, step, curr_user, appointee: nil)
      return "l'incarico è stato **annullato** da #{curr_user.name}" if kind=="canceled"
      is_male = appointee.nil? ? true : appointee.male?

      {
        ["proposal", "started"]  => "ha ricevuto una **proposta di incarico** da #{curr_user.name}",
        ["proposal", "accepted"] => "ha risposto **positivamente** alla proposta",
        ["proposal", "rejected"] => "ha risposto **negativamente** alla proposta",

        ["appoint", "started"]  => ( is_male ? "è stato **incaricato** da #{curr_user.name}" : "è stata **incaricata** da #{curr_user.name}"),
        ["appoint", "accepted"] => "ha **accettato** l'incarico",
        ["appoint", "rejected"] => "ha **rifiutato** l'incarico",

        ["direct_appoint", "started"]  => (curr_user==action.appointee.user ? ( is_male ? "si è preso l'**incarico**" : "si è presa l'**incarico**") : "ha ricevuto un **incarico diretto** da #{curr_user.name}"),
        ["direct_appoint", "accepted"] => "ha **confermato** l'incarico diretto",
        ["direct_appoint", "rejected"] => "ha **declinato** l'incarico diretto"
      }.fetch([kind, step], "?")
    end

end
