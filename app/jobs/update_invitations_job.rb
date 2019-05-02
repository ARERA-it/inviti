class UpdateInvitationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    count = Invitation.update_expired_statuses
    SuperuserNotificationMailer.with(count: count).expired_statuses.deliver_later
  end
end
