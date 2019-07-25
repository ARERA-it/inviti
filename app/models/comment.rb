# == Schema Information
#
# Table name: comments
#
#  id            :bigint(8)        not null, primary key
#  user_id       :bigint(8)
#  invitation_id :bigint(8)
#  content       :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :invitation
  audited associated_with: :invitation, only: :content

  before_save :append_audit_comment
  def append_audit_comment
    if new_record? # because before_update doesn't work
      self.audit_comment = "#{user.name} ha aggiunto un commento"
    else
      # do nothing
    end
  end

end
