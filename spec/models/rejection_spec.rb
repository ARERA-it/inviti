# == Schema Information
#
# Table name: rejections
#
#  id            :bigint           not null, primary key
#  invitation_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Rejection, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
