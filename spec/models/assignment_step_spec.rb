# == Schema Information
#
# Table name: assignment_steps
#
#  id               :bigint           not null, primary key
#  invitation_id    :bigint
#  description      :string
#  curr_user_id     :integer
#  assigned_user_id :integer
#  step             :integer
#  timestamp        :datetime
#  accept_id        :integer
#

require 'rails_helper'

RSpec.describe AssignmentStep, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
