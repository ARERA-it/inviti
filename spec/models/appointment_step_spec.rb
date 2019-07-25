# == Schema Information
#
# Table name: appointment_steps
#
#  id                    :bigint(8)        not null, primary key
#  appointment_action_id :bigint(8)
#  step                  :integer          default("started")
#  timestamp             :datetime
#  user_reply_id         :bigint(8)
#  comment               :text
#

require 'rails_helper'

RSpec.describe AppointmentStep, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
