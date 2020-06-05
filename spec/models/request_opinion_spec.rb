# == Schema Information
#
# Table name: request_opinions
#
#  id            :bigint           not null, primary key
#  invitation_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#

require 'rails_helper'

RSpec.describe RequestOpinion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
