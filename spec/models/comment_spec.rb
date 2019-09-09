# == Schema Information
#
# Table name: comments
#
#  id            :bigint           not null, primary key
#  user_id       :bigint
#  invitation_id :bigint
#  content       :text             default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Comment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
