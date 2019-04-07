# == Schema Information
#
# Table name: assignment_steps
#
#  id               :bigint(8)        not null, primary key
#  invitation_id    :bigint(8)
#  description      :string
#  curr_user_id     :integer
#  assigned_user_id :integer
#  step             :integer
#  timestamp        :datetime
#

require 'rails_helper'

RSpec.describe AssignmentStep, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
