# == Schema Information
#
# Table name: appointment_actions
#
#  id           :bigint(8)        not null, primary key
#  appointee_id :bigint(8)
#  group_id     :bigint(8)
#  user_id      :bigint(8)
#  kind         :integer
#  comment      :text
#  timestamp    :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe AppointmentAction, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
