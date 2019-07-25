# == Schema Information
#
# Table name: opinions
#
#  id            :bigint(8)        not null, primary key
#  user_id       :bigint(8)
#  invitation_id :bigint(8)
#  selection     :integer          default("undefined")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Opinion < ApplicationRecord
  audited associated_with: :invitation

  CHOICES = [ :undefined, :do_not_participate, :president_must_participate, :someone_else_must_participate ]

  belongs_to :user
  belongs_to :invitation
  enum selection: CHOICES

  scope :expressed, -> { where("selection>0") }

  before_save :append_audit_comment
  def append_audit_comment
    if new_record? # because before_update doesn't work
      # do nothing
    else
      self.audit_comment = "#{user.name} ha espresso un'opinione riguardo alla partecipazione"
    end
  end

  def Opinion.choices
    CHOICES.map{ |c| [c]}
  end

  def expressed?
    do_not_participate? || president_must_participate? || someone_else_must_participate?
  end
end
