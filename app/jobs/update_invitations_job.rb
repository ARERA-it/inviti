class UpdateInvitationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Invitation.update_invitation_expired_statuses
  end
end
