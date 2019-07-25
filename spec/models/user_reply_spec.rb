# == Schema Information
#
# Table name: user_replies
#
#  id                    :bigint(8)        not null, primary key
#  appointment_action_id :bigint(8)
#  token                 :string
#  status                :integer          default("not_yet")
#  comment               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'rails_helper'

RSpec.describe UserReply, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
