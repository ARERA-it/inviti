# == Schema Information
#
# Table name: opinions
#
#  id            :bigint           not null, primary key
#  user_id       :bigint
#  invitation_id :bigint
#  selection     :integer          default("undefined")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Opinion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
