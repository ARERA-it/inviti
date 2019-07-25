# == Schema Information
#
# Table name: appointees
#
#  id            :bigint(8)        not null, primary key
#  invitation_id :bigint(8)
#  user_id       :bigint(8)
#  status        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  description   :string
#

class Appointee < ApplicationRecord
  audited only: [:user_id, :status, :description], associated_with: :invitation
  attr_accessor :from_ui
  # has_associated_audits

  belongs_to :invitation
  belongs_to :user, optional: true # the person that is appointed
  has_many :actions, class_name: "AppointmentAction", foreign_key: "appointee_id", dependent: :destroy do
    def all_appoint
      where(kind: :appoint)
    end

    def all_proposal
      where(kind: :proposal)
    end
  end
  has_many :steps, through: :actions

  enum status: [:prop_waiting, :prop_accepted, :prop_refused, :app_waiting, :app_accepted, :app_refused, :direct_app, :direct_app_accepted, :direct_app_refused, :canceled]
  attr_accessor :display_name, :selected_id, :user_or_group, :ui_choice, :comment
  validate :pick_an_option, :existing_display_name
  scope :accepted, -> { where(status: [:app_accepted, :direct_app, :direct_app_accepted])}
  scope :waiting_n_accepted, -> { where(status: [:app_waiting, :app_accepted, :direct_app, :direct_app_accepted])}
  scope :waiting, -> { where(status: [:prop_waiting, :app_waiting])}
  # scope :waiting,  -> { where(status: [:prop_waiting, :prop_accepted, :prop_refused, :app_waiting, :app_refused, :direct_app_refused, :canceled])}
  after_update :update_appointee_status
  after_initialize :init_values

  before_save :append_audit_comment
  def append_audit_comment
    if new_record? # because before_update doesn't work
      # do nothing
    else
      self.audit_comment = "#{user.name} #{description || steps.last.description}"
    end
  end


  def update_status(kind: actions.last.kind, step: actions.last.steps.last.step, description: nil)
    # kind = actions.last.kind             #   :proposal, :appoint, :direct_appoint, :canceled
    # step = actions.last.steps.last.step  #   :started, :accepted, :rejected, :expired

    if s = resolve_status(kind, step)
      self.update(status: s, description: description)
    end
  end

  def update_appointee_status
    invitation.update_appointee_status
  end

  def name
    user.try(:name)
  end


  def resolve_status(kind, step)
    return :canceled if kind=='canceled'
    {
      ["proposal", "started"]  => :prop_waiting,
      ["proposal", "accepted"] => :prop_accepted,
      ["proposal", "rejected"] => :prop_refused,

      ["appoint", "started"]  => :app_waiting,
      ["appoint", "accepted"] => :app_accepted,
      ["appoint", "rejected"] => :app_refused,

      ["direct_appoint", "started"]  => :direct_app,
      ["direct_appoint", "accepted"] => :direct_app_accepted,
      ["direct_appoint", "rejected"] => :direct_app_refused
    }.fetch([kind, step], nil)
  end


  def display_name
    user.try(:display_name)
  end

  def display_name=(name)
    @display_name = name
  end

  def image?
    user.image?
  end

  def initials
    user.initials
  end



  def Appointee.ui_choices(current_status=nil)
    return [:send_proposal, :charge_w_email, :charge_w_consent] if current_status.nil?
    four_choices = [:send_proposal, :charge_w_email, :charge_w_consent, :cancel]
    return four_choices
    # h = {
    #   :prop_waiting => four_choices,
    #   :prop_accepted => four_choices,
    #   :prop_refused => four_choices,
    #   :app_waiting => four_choices,
    #   :app_accepted => four_choices,
    #   :app_refused => four_choices,
    #   :direct_app => four_choices,
    #   :direct_app_accepted => four_choices,
    #   :direct_app_refused => four_choices,
    #   :canceled => four_choices
    # }
    # h.fetch(current_status.to_sym, four_choices)
  end

  def init_values
    @from_ui = false
  end


  private

    def update_invitation_decision
      if !invitation.participate?
        invitation.update_attribute(:decision, :participate)
      end
    end

    def create_appointment_step
      step = direct_appointment? ? :accepted : :started
      steps.create(
        appointed_user_id: user_id,
        step: step,
        timestamp: Time.now
      )
    end

    def pick_an_option
      if ui_choice.blank? && from_ui
        errors.add(:ui_choice, "selezionare un'opzione")
      end
    end

    def existing_display_name
      if from_ui
        begin
          user_or_group=="group" ? Group.find(selected_id) : User.find(selected_id)
        rescue ActiveRecord::RecordNotFound
          errors.add(:display_name, "non è stato trovato")
        end
      end
    end

end
