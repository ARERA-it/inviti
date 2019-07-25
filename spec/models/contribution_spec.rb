# == Schema Information
#
# Table name: contributions
#
#  id            :bigint(8)        not null, primary key
#  invitation_id :bigint(8)
#  user_id       :bigint(8)
#  title         :string           default("")
#  note          :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Contribution, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
