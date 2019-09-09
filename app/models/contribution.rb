# == Schema Information
#
# Table name: contributions
#
#  id            :bigint           not null, primary key
#  invitation_id :bigint
#  user_id       :bigint
#  title         :string           default("")
#  note          :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Contribution < ApplicationRecord
  belongs_to :invitation
  belongs_to :user
  has_many_attached :contribution_files
  validates :title, presence: true
  audited  only: [:title, :note], associated_with: :invitation
  has_associated_audits

  before_save :append_audit_comment
  def append_audit_comment
    if new_record? # because before_update doesn't work
      self.audit_comment = "#{user.name} ha aggiunto un contributo"
    else
      # do nothing
    end
  end


  def filenames
    contribution_files.map(&:filename).join(', ')
  end
end
