class UpdateInvitationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Invitation.update_expired_statuses
  end
end
