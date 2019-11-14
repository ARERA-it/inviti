# == Schema Information
#
# Table name: follow_ups
#
#  id            :bigint           not null, primary key
#  invitation_id :bigint
#  status        :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe FollowUp, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
