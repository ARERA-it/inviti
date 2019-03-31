# == Schema Information
#
# Table name: accepts
#
#  id            :bigint(8)        not null, primary key
#  token         :string
#  invitation_id :bigint(8)
#  user_id       :bigint(8)
#  decision      :integer          default(0)
#  comment       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Accept < ApplicationRecord
  enum decision: [:not_yet, :accepted, :rejected]
  belongs_to :invitation
  belongs_to :user
  before_create :add_token

  after_update do |a|
    inv = a.invitation
    if a.accepted?
      inv.accept!
    elsif a.rejected?
      inv.reject!
    end
  end

  def add_token
    while Accept.find_by(token: (token = SecureRandom.hex))
      token = SecureRandom.hex
    end
    self.token = token
  end
end
