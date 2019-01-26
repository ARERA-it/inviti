# == Schema Information
#
# Table name: opinions
#
#  id            :bigint(8)        not null, primary key
#  user_id       :bigint(8)
#  invitation_id :bigint(8)
#  selection     :integer          default("undefined")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Opinion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
