# == Schema Information
#
# Table name: users
#
#  id                  :bigint(8)        not null, primary key
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
#  role                :integer          default("viewer")
#  title               :string(30)
#  appointeeable       :boolean          default(FALSE)
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :registerable, :recoverable, :rememberable, :validatable
  devise :cas_authenticatable, :trackable

  enum role: [:president, :advisor, :commissary, :secretary, :viewer, :admin]
  validates :email, uniqueness: true
  scope :appointeeable, -> { where(appointeeable: true) }
  has_and_belongs_to_many :invitations
  has_many :contributions, dependent: :nullify


  before_save do |r|
    r.username = r.username.downcase
    r.email    = "#{r.username}@arera.it" if r.username && r.email.blank?
    r.display_name = r.username if r.display_name.blank?
    r.initials = User.calc_initials(r.display_name) if r.initials.blank?
  end

  has_settings do |s|
    s.key :invitation, :defaults => { :visualization_mode => 'cards' }
  end


  def User.calc_initials(name)
    name.split(" ").map(&:first).join.upcase[0..1]
  rescue
    ""
  end

end
