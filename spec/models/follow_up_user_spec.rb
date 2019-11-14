# == Schema Information
#
# Table name: follow_up_users
#
#  id           :bigint           not null, primary key
#  follow_up_id :bigint
#  user_id      :bigint
#  dismissed    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe FollowUpUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
