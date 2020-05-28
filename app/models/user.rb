# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :inet
#  last_sign_in_ip     :inet
#  username            :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  display_name        :string
#  initials            :string(2)
#  email               :string
#  job_title           :string
#  role                :integer          default(4)
#  title               :string(30)
#  appointeeable       :boolean          default(FALSE)
#  advisor_group       :integer          default("not_advisor")
#  gender              :integer          default("male")
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :registerable, :recoverable, :rememberable, :validatable
  devise :cas_authenticatable, :trackable

  # enum role: [:president, :advisor, :commissary, :secretary, :viewer, :admin, :observer]
  enum advisor_group: [:not_advisor, :general_secretary, :external_relations, :board, :tester] # TODO: obsolete?
  enum gender: [:male, :female]

  validates :username, presence: true
  validates :email, uniqueness: true
  scope :appointeeable, -> { where(appointeeable: true) }
  has_many :user_invitations, class_name: "UserInvitation", foreign_key: "user_id"
  has_many :contributions, dependent: :nullify
  has_many :interactions, class_name: "UserInteraction", foreign_key: "user_id"
  has_many :appointees, dependent: :nullify
  has_many :rej_users, dependent: :destroy # TODO: remove this
  has_many :follow_up_users, dependent: :destroy
  has_many :follow_up_actions, dependent: :destroy
  has_and_belongs_to_many :group
  belongs_to :role


  before_save do |r|
    r.username      = r.username.downcase
    r.email         = "#{r.username}@#{ENV.fetch('DOMAIN', 'example.com')}" if r.username
    r.display_name  = r.username if r.display_name.blank?
    r.initials      = User.calc_initials(r.display_name) if r.initials.blank?
    # r.advisor_group = :not_advisor unless r.admin? # || r.advisor?
    # r.advisor_group = :board if r.commissary?
  end

  # ================
  def admin?
    r = role&.code
    r==Role::ADMIN || r==Role::SUPERUSER
  end

  def seen_invitations
    Hash[user_invitations.map{|ui| [ui.invitation_id, ui.seen_at]}]
  end

  has_settings do |s|
    s.key :invitation, :defaults => { :visualization_mode => 'cards' }
  end

  # def self.active_advisor_groups
  #   User.advisor_groups.keys[1..-1]
  # end

  def User.calc_initials(name)
    name.split(" ").map(&:first).join.upcase[0..1]
  rescue
    ""
  end

  # Get the list of all active advisor_groups
  # example: ["general_secretary", "external_relations"]
  # TODO: OBSOLETE, remove
  def User.active_advisor_groups
    User.where.not(advisor_group: "not_advisor").pluck(:advisor_group).uniq.sort
  end


  # Get the array of all active advisor_groups with users
  # example: {"general_secretary"=>[#<User id: 20, username: "john",...>, ... ], "external_relations"=>[#<User id: 18, username: "sarah",...>]}
  def User.active_advisor_groups_with_users
    res = {}
    User.advisor.each do |adv|
      adv_grp = adv.advisor_group
      if !res.has_key? adv_grp
        res[adv_grp] = []
      end
      res[adv_grp] << adv
    end
    res
  end

  def name
    display_name || username
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  def image?
    false
  end

  # User.advisor_users(["general_secretary","board"])
  def User.advisor_users(name_arr)
    User.where(advisor_group: name_arr)
  end


  # Any advisor (for each advisor_group) expressed
  # an opinion on invitation
  def User.any_advisor_expressed_an_opinion_on(invitation)
    User.active_advisor_groups_with_users.each_pair do |grp, users|
      intersection = invitation.opinions.expressed.pluck(:user_id) & users.pluck(:id)
      return true if intersection.any?
    end
    false
  end

  # All advisors (at least one for each advisor_group) expressed
  # an opinion on invitation
  def User.all_advisor_expressed_an_opinion_on(invitation)
    res = true
    User.active_advisor_groups_with_users.each_pair do |grp, users|
      intersection = invitation.opinions.expressed.pluck(:user_id) & users.pluck(:id)
      res = res && intersection.any?
    end
    res
  end
end
