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
#

class Invitation < ApplicationRecord
  DECISIONS = [ :waiting, :participate, :do_not_participate ]

  attr_accessor :from_date_and_time_view, :to_date_and_time_view

  has_many_attached :files
  has_one :opinion, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :users
  has_many :contributions, :dependent => :destroy

  belongs_to :appointee, class_name: "User", foreign_key: "appointee_id", required: false
  enum decision: DECISIONS

  after_initialize :set_date_views
  before_save :set_dates, :need_infos, :set_expired, :unset_appointee

  # default_scope { order(:from_date_and_time, :email_received_date_time) }
  scope :expired, -> { where(expired: true) }
  scope :not_expired, -> { where(expired: false) }
  scope :assigned, -> { where("decision=1 AND (appointee_id IS NOT NULL OR (alt_appointee_name = '') IS FALSE)") }
  scope :not_assigned, -> { where("decision<>1") }
  scope :info_provided, -> { where(need_infos: false) }
  scope :participate_or_maybe, -> { where("decision<>2") }
  scope :archived, -> { where("expired=TRUE OR decision=2") }

  def unset_appointee
    if do_not_participate? || waiting?
      self.appointee_id = nil
      self.alt_appointee_name = nil
    end
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
      alt_appointee_name = nil  # nome incaricato
      if stato>2
        if dice(0.167)
          alt_appointee_name = Faker::Name.name
        else
          appointee_id = appointeeables.sample
        end
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
        alt_appointee_name: alt_appointee_name,
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

end
