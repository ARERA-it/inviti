# == Schema Information
#
# Table name: follow_up_actions
#
#  id           :bigint           not null, primary key
#  follow_up_id :bigint
#  user_id      :bigint
#  fu_action    :integer          default("none_")
#  comment      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class FollowUpAction < ApplicationRecord
  belongs_to :follow_up
  belongs_to :user

  enum fu_action: [:none_, :sent_email]

  validate :present_one_of_the_two

  def present_one_of_the_two
    if none_?
      errors.add(:comment, "non può essere vuoto") if comment.blank?
    end
  end
end
