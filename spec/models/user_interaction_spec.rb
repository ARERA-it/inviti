# == Schema Information
#
# Table name: user_interactions
#
#  id              :bigint(8)        not null, primary key
#  user_id         :bigint(8)
#  controller_name :string(31)
#  action_name     :string(31)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe UserInteraction, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
