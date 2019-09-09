# == Schema Information
#
# Table name: accepts
#
#  id            :bigint           not null, primary key
#  token         :string
#  invitation_id :bigint
#  user_id       :bigint
#  decision      :integer          default("not_yet")
#  comment       :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  proposal      :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Accept, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
