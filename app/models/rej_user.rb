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

class RejUser < ApplicationRecord
  belongs_to :rejection
  belongs_to :user
end
