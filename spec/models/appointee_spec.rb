# == Schema Information
#
# Table name: appointees
#
#  id            :bigint           not null, primary key
#  invitation_id :bigint
#  user_id       :bigint
#  status        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  description   :string
#

require 'rails_helper'

RSpec.describe Appointee, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
