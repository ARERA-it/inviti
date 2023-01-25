# == Schema Information
#
# Table name: permissions
#
#  id          :bigint           not null, primary key
#  description :text
#  domain      :string
#  controller  :string
#  action      :string
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  code        :string
#

require 'rails_helper'

RSpec.describe Permission, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
