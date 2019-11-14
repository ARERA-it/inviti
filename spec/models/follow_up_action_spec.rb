# == Schema Information
#
# Table name: follow_up_actions
#
#  id           :bigint           not null, primary key
#  follow_up_id :bigint
#  user_id      :bigint
#  fu_action    :integer          default(0)
#  comment      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe FollowUpAction, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
