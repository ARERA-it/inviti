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

require 'rails_helper'

RSpec.describe AttendeeStep, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
