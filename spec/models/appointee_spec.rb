# == Schema Information
#
# Table name: appointees
#
#  id            :bigint(8)        not null, primary key
#  invitation_id :bigint(8)
#  user_id       :bigint(8)
#  status        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  description   :string
#

require 'rails_helper'

RSpec.describe Appointee, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
