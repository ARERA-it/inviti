# == Schema Information
#
# Table name: accepts
#
#  id            :bigint(8)        not null, primary key
#  token         :string
#  invitation_id :bigint(8)
#  user_id       :bigint(8)
#  decision      :integer          default(0)
#  comment       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Accept, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
