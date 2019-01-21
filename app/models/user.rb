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

  enum role: [:top, :advisor, :commissary, :secretary, :viewer, :admin]
  validates :email, uniqueness: true
  scope :appointeeable, -> { where(appointeeable: true) }

  before_save do |r|
    r.initials = User.calc_initials(r.display_name) if r.initials.blank?
    r.email = User.calc_email(r.display_name) if r.email.blank?
    r.username = r.email if r.username.blank?
  end



  def User.calc_initials(name)
    name.split(" ").map(&:first).join.upcase[0..1]
  rescue
    ""
  end

end
