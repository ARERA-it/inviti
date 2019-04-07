# == Schema Information
#
# Table name: attendee_steps
#
#  id            :bigint(8)        not null, primary key
#  invitation_id :bigint(8)
#  description   :string
#  user_id       :bigint(8)
#  step          :integer
#  timestamp     :datetime
#

class AttendeeStep < ApplicationRecord
  belongs_to :invitation
  belongs_to :user # the current_user
  enum step: [:nil, :assigned, :accepted, :rejected]



end
