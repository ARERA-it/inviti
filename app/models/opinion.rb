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
  CHOICES = [ :undefined, :do_not_participate, :president_must_participate, :someone_else_must_participate ]

  belongs_to :user
  belongs_to :invitation
  enum selection: CHOICES

  after_save do |o|
    o.invitation.update_column(:opinion_expressed, o.expressed?)
  end

  def Opinion.choices
    CHOICES.map{ |c| [c]}
  end

  def expressed?
    do_not_participate? || president_must_participate? || someone_else_must_participate?
  end
end
