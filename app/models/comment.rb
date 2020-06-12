# == Schema Information
#
# Table name: comments
#
#  id            :bigint           not null, primary key
#  user_id       :bigint
#  invitation_id :bigint
#  content       :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :invitation
  audited associated_with: :invitation, only: :content

  validates :content, presence: true

  before_save :append_audit_comment
  before_validation :clear_content

  def append_audit_comment
    if new_record? # because before_update doesn't work
      self.audit_comment = "#{user.name} ha aggiunto un commento"
    else
      # do nothing
    end
  end

  def clear_content
    self.content = content.strip
  end
end
