# == Schema Information
#
# Table name: accepts
#
#  id            :bigint(8)        not null, primary key
#  token         :string
#  invitation_id :bigint(8)
#  user_id       :bigint(8)
#  decision      :integer          default("not_yet")
#  comment       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  proposal      :boolean          default(FALSE)
#

# class used to manage accept or reject of invitation
#
class Accept < ApplicationRecord
  enum decision: [:not_yet, :accepted, :rejected]
  belongs_to :invitation
  belongs_to :user
  before_create :add_token

  after_update do |a|
    inv = a.invitation
    if a.accepted?
      a.proposal ? inv.accept_proposal(a) : inv.call_accept(a)
    elsif a.rejected?
      a.proposal ? inv.reject_proposal(a) : inv.call_reject(a)
    end
  end

  after_create do
    if proposal
      AppointeeMailer.with(inv: invitation.id, acc: id).proposal_to_a_board_members.deliver_later
    else
      AppointeeMailer.with(inv: invitation.id, acc: id).appointed.deliver_later
      invitation.assignment_steps.create(assigned_user: user, step: :mailed)
    end
  end

  def add_token
    while Accept.find_by(token: (token = SecureRandom.hex))
      token = SecureRandom.hex
    end
    self.token = token
  end
end
