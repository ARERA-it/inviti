# == Schema Information
#
# Table name: request_opinions
#
#  id            :bigint(8)        not null, primary key
#  destination   :string
#  invitation_id :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe RequestOpinion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
