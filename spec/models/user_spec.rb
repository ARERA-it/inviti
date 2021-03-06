# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :inet
#  last_sign_in_ip     :inet
#  username            :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  display_name        :string
#  initials            :string(2)
#  email               :string
#  job_title           :string
#  role_id             :integer          default(4)
#  title               :string(30)
#  appointeeable       :boolean          default(FALSE)
#  advisor_group       :integer          default(0)
#  gender              :integer          default("male")
#

require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
