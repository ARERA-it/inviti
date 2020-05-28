# == Schema Information
#
# Table name: permissions
#
#  id          :bigint           not null, primary key
#  role_id     :bigint
#  description :text
#  controller  :string
#  action      :string
#  permitted   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Permission, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
