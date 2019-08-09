# == Schema Information
#
# Table name: invitations
#
#  id                       :bigint           not null, primary key
#  title                    :string           default("")
#  location                 :string           default("")
#  from_date_and_time       :datetime
#  to_date_and_time         :datetime
#  organizer                :string           default("")
#  notes                    :text             default("")
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
#  delegation_notes         :text             default("")
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  decision                 :integer          default("waiting")
#  state                    :integer          default("no_info")
#  appointee_message        :string           default("")
#  email_decoded            :text
#  appointee_status         :integer          default("nobody")
#  appointee_steps_count    :integer          default(0)
#  public_event             :boolean          default(FALSE)
#

class Invitation < ApplicationRecord
  attr_accessor :alt_appointee_name
  attr_accessor :accept_model, :curr_user
  include FakeInvitations
  include EmailDecoder
  audited except: [:email_id, :email_body_preview, :email_body, :email_decoded]
  has_associated_audits # :appointees, :contributions, :comments

  include AASM

  enum state: {
    no_info: 0,
    info: 1, # da assegnare
    declined: 5,
    past: 6
  }

  enum appointee_status: [:nobody, :at_work, :ibrid, :one_or_more]
  enum org_category: [:undefined, :by_company, :partecipated, :general]

  def update_appointee_status
    c = appointees.accepted.count # appointed
    w = appointees.waiting.count # waiting for a confirmation or proposed

    step_count = appointees.map{|a| a.steps.count}.sum
    update_column(:appointee_steps_count, step_count)

    case
    when c==0 && w==0
      self.nobody!
    when c>0 && w>0
      self.ibrid!
    when c==0 && w>0
      self.at_work!
    when c>0 && w==0
      self.one_or_more!
    end
  end

  aasm column: :state, enum: true, whiny_transitions: false do
    state :no_info, initial: true
    state :info
    state :declined # nessuno partecipa
    state :past

    event :info_added do
      transitions from: :no_info, to: :info
    end

    event :decline do
      transitions from: [:no_info, :info], to: :declined
    end

    event :accept do
      transitions from: :declined, to: :info
    end

    event :pass do
      transitions from: :info, to: :past
    end
  end

  after_save do |i|
    if i.no_info? and i.has_basic_info?
      i.info_added!
    end
    i.pass! if i.is_expired?
  end

  # prop_waiting, :prop_accepted, :prop_refused, :app_waiting, :app_accepted, :app_refused, :direct_app, :direct_app_accepted, :direct_app_refused, :canceled
  def actions_after_decline(comment: "", user: )
    appointees.where(status: [:prop_waiting, :prop_accepted, :app_waiting, :app_accepted, :direct_app, :direct_app_accepted]).each do |appointee|
      appointee.actions.create(kind: :canceled, comment: comment, user: user)
    end
  end

  # TODO: remove (is used with Accept model)
  def call_reject(accpt)
    @accept_model = accpt
    reject!
  end

  # TODO: remove (is used with Accept model)
  def call_accept(accpt)
    @accept_model = accpt
    accept!
  end


  def update_participation(decision, comment="", current_user)
    if is_expired?
      pass! if !past?
    else
      if decision=="participate"
        accept!  # -> enum: :state
        participate! # -> enum: :decision
      elsif decision=="do_not_participate"
        decline! # -> enum: :state
        do_not_participate! # -> enum: :decision
        actions_after_decline(comment: comment, user: current_user)
      end

    end
  end



  attr_accessor :from_date_and_time_view, :to_date_and_time_view
  attr_accessor :send_email

  has_many_attached :files
  has_many :opinions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :users # # TODO: obsolete
  has_many :user_invitations, dependent: :destroy

  # has_many :invitation_seens, class_name: "UserInvitation", foreign_key: "invitation_id"

  has_many :contributions, dependent: :destroy
  has_many :accepts, dependent: :destroy
  has_many :assignment_steps, -> { order "timestamp ASC" }, dependent: :destroy
  has_many :request_opinions, dependent: :destroy
  has_many :appointees, dependent: :destroy
  # accepts_nested_attributes_for :appointees, allow_destroy: true

  # TODO: remove the following
  belongs_to :appointee, class_name: "User", foreign_key: "appointee_id", required: false

  after_initialize :set_date_views
  before_save :set_dates, :unset_appointee, :append_audit_comment
  before_create :decode_mail_body
  def append_audit_comment
    if new_record? # because before_update doesn't work
      # do nothing
    else
      list = changes.keys.map{|attr| I18n.t(attr, scope: [:activerecord, :attributes, :invitation])}
      user_name = curr_user.nil? ? "Qualcuno" : curr_user.name
        if list.size==1
        self.audit_comment = "#{user_name} ha apportato una modifica all'attributo #{list.to_sentence}"
      elsif list.size>1
        self.audit_comment = "#{user_name} ha apportato modifiche ai seguenti attributi: #{list.to_sentence}"
      end
    end
  end


  scope :expired,        -> { where(state: :past) }
  scope :not_expired,    -> { where.not(state: :past) }
  # scope :to_be_assigned, -> { where(state: [:info, :rejected]) }

  #
  # scope :to_be_assigned, -> { where(appointee_status: [:info, :rejected]) }
  # scope :are_assigned,   -> { where(state: [:assigned, :accepted])}
  # scope :alive,          -> { where(state: [:info, :assigned, :accepted, :rejected])}

  # scope :no_info -> is a state
  scope :to_be_assigned, -> { where(state: :info, appointee_status: :nobody) }
  scope :waitin,         -> { where(state: :info, appointee_status: [:ibrid, :at_work]) } # almeno uno in attesa
  scope :are_assigned,   -> { where(state: :info, appointee_status: [:one_or_more]) }
  scope :archived,       -> { where(state: [:declined, :past]) }


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

  def appointee
    appointees.first
  end

  def users_who_was_asked_for_an_opinion
    request_opinions.map{|ro| ro.groups_users}.flatten.uniq
  end

  def appointed_users
    appointees.map(&:user)
  end

  # Let you know if the record (for current_user) in new or has been changed after last :show action
  def new_or_changed?(curr_user, hash: nil)
    if hash # {invitation_id => seen_at} hash # passed for batch processing, in order to bypass UserInvitation.find_by() query
      last_seen = hash[id]
      return :new if last_seen.nil?
    else
      ui = UserInvitation.find_by(user: curr_user, invitation: self)
      return :new if ui.nil?
      last_seen = ui.seen_at
    end
    # PostPolicy.new(current_user, @post).update?

    # if own_and_associated_audits.where("created_at>? AND user_id!=?", last_seen, curr_user).any?{|a| policy(a.auditable_type.underscore.to_sym).show? }
    if own_and_associated_audits.where("created_at>? AND user_id!=?", last_seen, curr_user).select{|a| a.comment }.any? # .any?{|a| "#{a.auditable_type}Policy".constantize.send(:new, curr_user, a.auditable_type.constantize.send(:find, a.auditable_id)).show? }
      :changed
    else
      :no_changes
    end
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

  def is_expired?
    event_date = to_date_and_time.try(:to_date) || from_date_and_time.try(:to_date)
    if event_date
      event_date<Date.today
    else
      false
    end
  end

  # Save all Invitation the are 'alive' (are 'alive' all inv. whose state is not 'no_info', 'declined' or 'past')
  # will return the number of invitations whose state has passed to 'past'
  def Invitation.update_expired_statuses
    Invitation.save_alive
  end

  # Save all Invitation the are 'alive' (are 'alive' all inv. whose state is not 'no_info', 'declined' or 'past')
  # will return the number of invitations whose state has passed to 'past'
  def Invitation.save_alive
    c1 = Invitation.where(state: :past).count
    Invitation.where.not(state: :past).each(&:save)
    c2 = Invitation.where(state: :past).count
    c2-c1
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
