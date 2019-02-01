# == Schema Information
#
# Table name: contributions
#
#  id            :bigint(8)        not null, primary key
#  invitation_id :bigint(8)
#  user_id       :bigint(8)
#  title         :string
#  note          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Contribution < ApplicationRecord
  belongs_to :invitation
  belongs_to :user
  has_many_attached :contribution_files
  validates :title, presence: true
end
