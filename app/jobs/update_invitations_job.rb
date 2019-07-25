class UpdateInvitationsJob < ApplicationJob
  queue_as :default

  # SuperuserNotificationMailer.with(count: Invitation.update_expired_statuses).expired_statuses.deliver_later
  def perform(*args)
    count = Invitation.update_expired_statuses
    SuperuserNotificationMailer.with(count: count).expired_statuses.deliver_later
  end
end
