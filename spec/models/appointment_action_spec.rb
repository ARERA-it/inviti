# == Schema Information
#
# Table name: appointment_actions
#
#  id           :bigint           not null, primary key
#  appointee_id :bigint
#  group_id     :bigint
#  user_id      :bigint
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
