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
#  role_id             :integer          default(4)
#  title               :string(30)
#  appointeeable       :boolean          default(FALSE)
#  advisor_group       :integer          default(0)
#  gender              :integer          default("male")
#

# TODO: advisor_group field is OBSOLETE

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :registerable, :recoverable, :rememberable, :validatable
  devise :cas_authenticatable, :trackable

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
  has_and_belongs_to_many :groups
  belongs_to :role, optional: true


  before_save do |r|
    r.username      = r.username.downcase
    r.display_name  = r.username if r.display_name.blank?
    r.initials      = User.calc_initials(r.display_name) if r.initials.blank?
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

  def User.calc_initials(name)
    name.split(" ").map(&:first).join.upcase[0..1]
  rescue
    ""
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

  # Get all users present in a group you can ask for an opinion
  def User.to_ask_an_opinion
    User.joins(:group).where('groups.ask_opinion' => true)
  end
end
