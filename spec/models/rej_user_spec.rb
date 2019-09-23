# == Schema Information
#
# Table name: rej_users
#
#  id           :bigint           not null, primary key
#  rejection_id :bigint
#  user_id      :bigint
#  dismissed    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe RejUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
