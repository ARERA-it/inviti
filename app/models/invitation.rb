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
#  need_info                :boolean          default(TRUE)
#  opinion_expressed        :boolean          default(FALSE)
#  expired                  :boolean          default(FALSE)
#  state                    :integer          default("no_info")
#  appointee_message        :string
#  email_decoded            :text
#  email_text_part          :text
#  email_html_part          :text
#

class Invitation < ApplicationRecord
  include AASM

  enum state: {
    no_info: 0,
    info: 1,
    appointee: 2,
    accepted: 3,
    rejected: 4
  }

  aasm column: :state, enum: true, whiny_transitions: false do
    state :no_info, initial: true
    state :info
    state :appointee
    state :accepted
    state :rejected
    state :archived

    event :add_info do
      transitions from: :no_info, to: :info
    end

    # Assegna l'incarico a qualcuno
    event :instructs, after: :mail_to_appointee do
      transitions from: :info, to: :appointee
      transitions from: :appointee, to: :appointee # OOOOCHIOOO!
    end

    event :accept, after: :actions_after_accept do
      transitions from: :appointee, to: :accepted
    end

    event :reject, after: :actions_after_reject do
      transitions from: :appointee, to: :rejected
    end

    event :reset_appointee, after: :resetting_appointee do
      transitions from: :rejected, to: :info
    end

    event :archive do
      transitions to: :archived
    end
  end



  after_save do |i|
    if i.no_info?
      if i.has_basic_info?
        i.add_info!
      end
    end
    if i.info?
      i.instructs! if i.appointee_id #|| i.alt_appointee_name
    end

  end

  def has_basic_info?
    !title.blank? && !location.blank? && !from_date_and_time.nil?
  end

  def mail_to_appointee
    if appointee_id
      if Rails.env=="development" && appointee.email=="ibuetti@arera.it"
        acc = Accept.create(invitation_id: id, user_id: appointee_id)
        puts "------> #{acc.inspect}"
        AppointeeMailer.with(inv: id, acc: acc.id).appointed.deliver_later
        write_appointee_message
      else
        if !appointee.president?
          acc = Accept.create(invitation_id: id, user_id: appointee_id)
          AppointeeMailer.with(inv: id, acc: acc.id).appointed.deliver_later
          write_appointee_message
        else
          clear_appointee_message
        end
      end
    end
  end

  def actions_after_accept
    update_column(:appointee_message, "#{appointee.display_name} ha accettato l'incarico")
  end


  def actions_after_reject
    # TODO: send an email to president
    update_column(:appointee_message, "#{appointee.display_name} ha rifiutato l'incarico")
    reset_appointee!
  end

  def resetting_appointee
    # update_columns(appointee_id: nil, alt_appointee_name: nil)
    update_columns(appointee_id: nil)
  end

  def write_appointee_message
    # TODO: aggiungi QUANDO è stata inviata
    t = Time.now
    update_column(:appointee_message, "E' stata inviata un'email a #{appointee.display_name}") # livestamp(dt)
  end

  def clear_appointee_message
    update_column(:appointee_message, "")
  end

  def user_display_name
    appointee.try(:display_name)
  end

  DECISIONS = [ :waiting, :participate, :do_not_participate ]

  attr_accessor :from_date_and_time_view, :to_date_and_time_view

  has_many_attached :files
  has_one :opinion, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :users
  has_many :contributions, :dependent => :destroy

  belongs_to :appointee, class_name: "User", foreign_key: "appointee_id", required: false
  enum decision: DECISIONS # zero based

  after_initialize :set_date_views
  before_save :set_dates, :need_infos, :set_expired, :unset_appointee  # :clear_alt_appointee_name, :nullify_appointee_id

  scope :expired, -> { where(expired: true) }
  scope :not_expired, -> { where(expired: false) }
  # scope :assigned, -> { where("decision=1 AND (appointee_id IS NOT NULL OR alt_appointee_name IS NOT NULL)") }
  scope :assigned, -> { where("decision=1 AND appointee_id IS NOT NULL") }
  scope :info_provided, -> { where(need_infos: false) }
  scope :missing_info, -> { where("title IS NULL AND location IS NULL AND from_date_and_time IS NULL") }
  scope :filled_info, -> { where.not("title IS NULL AND location IS NULL AND from_date_and_time IS NULL") }

  scope :to_be_filled, -> { missing_info.not_expired }
  # not_assigned è sbagliata: prende anche i declinati
  # scope :not_assigned, -> { filled_info.where("decision<>1 OR (appointee_id IS NULL AND (alt_appointee_name = '') IS TRUE)").not_expired }
  # scope :not_assigned, -> { filled_info.where("decision=0 OR (appointee_id IS NULL AND alt_appointee_name IS NULL)").not_expired }
  # scope :not_assigned, -> { filled_info.where("decision=0 OR (decision=1 AND appointee_id IS NULL AND alt_appointee_name IS NULL)").not_expired }
  scope :not_assigned, -> { filled_info.where("decision=0 OR (decision=1 AND appointee_id IS NULL)").not_expired }
  scope :running, -> { assigned.not_expired }
  scope :archived, -> { where("expired=TRUE OR decision=2") }


  def Invitation.rest
    Invitation.pluck(:id) - Invitation.to_be_filled.pluck(:id) - Invitation.not_assigned.pluck(:id) - Invitation.running.pluck(:id) - Invitation.archived.pluck(:id)
  end

  # Cancella il nome del partecipante_altro se appointee_id è >0
  # def clear_alt_appointee_name
  #   self.alt_appointee_name = nil if appointee_id && appointee_id>0
  # end

  # def nullify_appointee_id
  #   self.appointee_id=nil if appointee_id==0 || appointee_id=='0'
  # end

  def unset_appointee
    if do_not_participate? || waiting?
      self.appointee_id = nil
      # self.alt_appointee_name = nil
    end
    # self.alt_appointee_name = nil if alt_appointee_name==''
  end

  def need_infos
    self.need_info = title.blank? || location.blank? || from_date_and_time.blank?
  end

  def set_expired
    event_date = to_date_and_time.try(:to_date) || from_date_and_time.try(:to_date)
    exp = event_date && event_date<Date.today
    exp = false if exp.nil?
    self.expired = exp
  end

  def rejected?
    do_not_participate?
  end

  def expired_changed?
    event_date = to_date_and_time.try(:to_date) || from_date_and_time.try(:to_date)
    exp = event_date && event_date<Date.today
    exp = false if exp.nil?
    expired!=exp
  end


  def Invitation.update_invitation_expired_statuses
    Invitation.not_expired.each do |inv|
      inv.save if inv.expired_changed?
    end
  end

  def Invitation.decisions
    DECISIONS.map{ |c| [c]}
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

  # Invitation.create_fake_records(30, email_status_only: true)
  def Invitation.create_fake_records(size=30, email_status_only: false)
    a1 = ["Congresso", "Simposio", "Convegno", "Meeting", "Evento"]
    a2 = ["Trasmissione televisiva"]
    a23 = ["Rai 1", "Rai 2", "Rai 3", "Canale 5", "La7", "Sky"]
    example_pdfs = Dir[File.join(Rails.root, 'example_pdfs', '*')]
    appointeeables = User.appointeeable.pluck(:id)
    advisor_ids = User.advisor.pluck(:id)

    size.times do
      stato = email_status_only ? 0 : rand(6)
      # stato 0: solo dati email
      # stato 1: dati compilati
      # stato 2: parere espresso
      # stato 3: partecipante assegnato
      # stato 4: invito rifiutato
      # stato 5: invito passato
      org = nil
      subj = dice(0.5) ? "#{a1.sample} #{org = Faker::University.name}" : "#{a2.sample} #{org = a23.sample}"
      from_dt = Faker::Time.between(2.weeks.ago, 3.weeks.from_now, :all)

      appointee_id = nil    # id incaricato
      # alt_appointee_name = nil  # nome incaricato
      if stato>2
        appointee_id = appointeeables.sample
        # if dice(0.167)
        #   alt_appointee_name = Faker::Name.name
        # else
        #   appointee_id = appointeeables.sample
        # end
      end


      i = Invitation.create(
        email_id: (Invitation.last.try(:email_id) || 1000).to_i + 1,
        email_from_name: Faker::Name.name,
        email_from_address: Faker::Internet.email,
        email_subject: subj,
        email_body_preview: Faker::Lorem.sentence,
        email_body: Faker::Lorem.paragraph,
        email_received_date_time: Faker::Time.between(6.weeks.ago, 2.weeks.ago, :all),
        location: stato>0 ? Faker::Address.city : nil,
        from_date_and_time: stato>0 ? from_dt : nil,
        to_date_and_time: stato>0 ? (dice(0.5) ? from_dt+2.hour : nil): nil,
        organizer: stato>0 ? org : nil,
        notes: stato>0 && dice(0.2) ? Faker::Lorem.paragraph : nil,
        appointee_id: appointee_id,
        # alt_appointee_name: alt_appointee_name,
        delegation_notes: dice(0.25) ? Faker::Lorem.sentence : ""
      )
      if i.nil?
        puts i.errors
      end
      if i && stato>1
        i.create_opinion(user_id: advisor_ids.sample, selection: Opinion::CHOICES[1..-1].sample)
      end
      if dice(0.4)
        pdfs = example_pdfs.clone.shuffle
        pdf = pdfs.pop
        i.files.attach(io: File.open(pdf), filename: File.basename(pdf))
        if dice(0.4) # a second file will be attached
          pdf = pdfs.pop
          i.files.attach(io: File.open(pdf), filename: File.basename(pdf))
        end
      end
    end
  end
end
