# == Schema Information
#
# Table name: invitations
#
#  id                       :bigint(8)        not null, primary key
#  title                    :string
#  location                 :string
#  from_date_and_time       :datetime
#  to_date_and_time         :datetime
#  organizer                :string
#  notes                    :text
#  email_id                 :string
#  email_from_name          :string
#  email_from_address       :string
#  email_subject            :string
#  email_body_preview       :string
#  email_body               :text
#  email_received_date_time :datetime
#  has_attachments          :boolean
#  attachments              :string
#  appointee_id             :integer
#  alt_appointee_name       :string
#  delegation_notes         :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  decision                 :integer          default("waiting")
#  state                    :integer          default("no_info")
#  appointee_message        :string
#  email_decoded            :text
#  email_text_part          :text
#  email_html_part          :text
#

class Invitation < ApplicationRecord
  attr_accessor :accept_model
  include FakeInvitations
  include EmailDecoder
  audited
  has_associated_audits

  include AASM

  enum state: {
    no_info: 0,
    info: 1, # da assegnare
    assigned: 2,
    accepted: 3,
    rejected: 4,
    declined: 5,
    past: 6

  }

  aasm column: :state, enum: true, whiny_transitions: false do
    state :no_info, initial: true
    state :info
    state :assigned
    state :accepted
    state :rejected # l'incaricato rifiuta
    state :declined # nessuno partecipa
    state :past

    event :info_added do
      transitions from: :no_info, to: :info
    end

    # Assegna l'incarico a qualcuno
    event :instructs, after: :actions_after_assign do
      transitions from: :info, to: :assigned
      transitions from: :assigned, to: :assigned # incarica qualcun altro, OOOOCHIOOO!
    end

    event :accept, after: :actions_after_accept do
      transitions from: :assigned, to: :accepted
    end

    event :reject, after: :actions_after_reject do
      transitions from: :assigned, to: :rejected
    end


    # when call reset_assigned, appointee_id must already be nil
    event :reset_assigned do
      transitions from: :rejected, to: :info
    end

    event :cancel_assignment, after: :actions_after_cancel_assignment do
      transitions from: [:assigned, :accepted, :rejected], to: :info
    end

    event :decline, after: :actions_after_decline do
      transitions from: [:no_info, :info, :assigned, :accepted, :rejected], to: :declined
    end

    event :pass do
      transitions from: [:info, :assigned, :accepted, :rejected], to: :past
    end
  end

  after_save do |i|
    if i.no_info? and i.has_basic_info?
      i.info_added!
    end
    if i.info? and i.appointee_id
      i.instructs!
    end
    if i.decision_changed_to_not_participate?
      i.decline!
    end
    if i.decision_changed_to_wait?
      i.cancel_assignment!
    end
    i.pass! if i.is_expired
  end

  def actions_after_decline
    # TODO: maybe email to someone
    update_attribute(:appointee_id, nil)
    assignment_steps.create(step: :declined)
  end

  def decision_changed_to_not_participate?
    dec_change = saved_change_to_attribute(:decision) # nil or ["waiting", "do_not_participate"]
    dec_change && dec_change[1]=="do_not_participate"
  end

  def decision_changed_to_wait?
    dec_change = saved_change_to_attribute(:decision) # nil or ["waiting", "do_not_participate"]
    dec_change && dec_change[1]=="waiting"
  end

  def call_reject(accpt)
    @accept_model = accpt
    reject!
  end

  def call_accept(accpt)
    @accept_model = accpt
    accept!
  end

  # No state change
  def accept_proposal(accpt)
    assignment_steps.create(assigned_user_id: accpt.user_id, accept: accpt, step: :accepted_proposal)
  end

  # No state change
  def reject_proposal(accpt)
    assignment_steps.create(assigned_user_id: accpt.user_id, accept: accpt, step: :rejected_proposal)
  end

  def actions_after_assign
    # logger.debug("---> actions_after_assign")
    if appointee_id
      @send_email='0' if appointee.president?
      if @send_email=='1'
        acc = accepts.create(user: appointee)
      else
        assignment_steps.create(assigned_user: appointee, step: :assigned_yet_accepted)
        accept!
      end
    end
  end

  def proposal_to_all_board_members
    User.commissary.each do |u|
      acc = accepts.create(user: u, proposal: true)
      break if Rails.env=="development" #
    end
    assignment_steps.create(step: :proposal_to_all_board_members)
  end

  def actions_after_cancel_assignment
    assignment_steps.create(assigned_user: appointee, step: :assigned)
  end

  def actions_after_accept
    assignment_steps.create(assigned_user_id: appointee.id, accept: accept_model, step: :accepted)
  end

  def actions_after_reject
    # TODO: send an email to president
    assignment_steps.create(assigned_user_id: appointee.id, accept: @accept_model, step: :rejected)
    update_columns(appointee_id: nil)
    reset_assigned!
  end

  def resetting_assigned
    # update_columns(appointee_id: nil, alt_appointee_name: nil)
    # update_columns(appointee_id: nil)
    # byebug
  end



  def user_display_name
    appointee.try(:display_name)
  end




  attr_accessor :from_date_and_time_view, :to_date_and_time_view
  attr_accessor :send_email

  has_many_attached :files
  has_many :opinions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :users
  has_many :contributions, dependent: :destroy
  has_many :accepts, dependent: :destroy
  has_many :assignment_steps, -> { order "timestamp ASC" }, dependent: :destroy
  has_many :request_opinions, dependent: :destroy

  belongs_to :appointee, class_name: "User", foreign_key: "appointee_id", required: false

  after_initialize :set_date_views
  before_save :set_dates, :unset_appointee
  before_create :decode_mail_body


  scope :expired, -> { past }
  # TODO: sostituisci tutte le occorrenze di expired con past
  scope :to_be_assigned, -> { where("state=1 or state=4") }
  scope :are_assigned, -> { where("state=2 OR state=3")}
  scope :archived, -> { where("state>4") } # declined or past
  scope :not_expired, -> { where.not(state: 6) }
  scope :alive, -> { where("state>0 AND state<5")}



  # Check if there are invitation records that are not catch by UI selectors
  def Invitation.rest
    Invitation.pluck(:id) - Invitation.no_info.pluck(:id) - Invitation.to_be_assigned.pluck(:id) - Invitation.are_assigned.pluck(:id) - Invitation.archived.pluck(:id)
  end


  def unset_appointee
    if do_not_participate? || waiting?
      self.appointee_id = nil
      # self.alt_appointee_name = nil
    end
    # self.alt_appointee_name = nil if alt_appointee_name==''
  end

  def rejected?
    do_not_participate?
  end

  # valutarne la necessità... ----------------------------------

  # sotto sono OK ------------------------------------------------

  # -> appointee panel: dropdown selection
  DECISIONS = [ :waiting, :participate, :do_not_participate ]
  enum decision: DECISIONS # zero based
  def Invitation.decisions
    DECISIONS.map{ |c| [c]}
  end

  def has_basic_info?
    !title.blank? && !location.blank? && !from_date_and_time.nil?
  end

  def is_expired
    event_date = to_date_and_time.try(:to_date) || from_date_and_time.try(:to_date)
    exp = event_date && event_date<Date.today
    exp = false if exp.nil?
    exp
  end

  # Save all Invitation the are 'alive' (are 'alive' all inv. whose state is not 'no_info', 'declined' or 'past')
  # will return the number of invitations whose state has passed to 'past'
  def Invitation.update_expired_statuses
    Invitation.save_alive
  end

  # Save all Invitation the are 'alive' (are 'alive' all inv. whose state is not 'no_info', 'declined' or 'past')
  # will return the number of invitations whose state has passed to 'past'
  def Invitation.save_alive
    Invitation.alive.each(&:save)
    count = 0
    Invitation.alive.each do |i|
      if i.saved_change_to_state && i.saved_change_to_state.last=="past" # nil or ["no_info", "info"]
        count += 1
      end
    end
    count
  end

  def location!
    location || I18n.t(:somewhere)
  end

  def set_date_views
    self.from_date_and_time_view = from_date_and_time.strftime("%d-%m-%Y %H:%M") if from_date_and_time
    self.to_date_and_time_view = to_date_and_time.strftime("%d-%m-%Y %H:%M") if to_date_and_time
  end

  def set_dates
    self.from_date_and_time = Time.parse(from_date_and_time_view).strftime("%Y-%m-%d %H:%M") if !from_date_and_time_view.blank?
    self.to_date_and_time = Time.parse(to_date_and_time_view).strftime("%Y-%m-%d %H:%M") if !to_date_and_time_view.blank?
  end

  def decode_mail_body
    self.email_decoded = convert_dash_dash(email_body) # -> a module EmailDecoder method
  end

end
